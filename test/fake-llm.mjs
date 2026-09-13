// A tiny fake OpenAI-compatible endpoint for the smoke tests. No dependencies.
// Answers every chat completion with a fixed sentinel, as JSON or as an SSE
// stream depending on what the client asks for, so a harness can complete one
// prompt without a real model. Prints the prompts it receives to stderr.
import { createServer } from 'node:http'

const ANSWER = process.env.FAKE_ANSWER ?? 'SMOKE_OK_42'
const PORT = Number(process.env.FAKE_PORT ?? 0)

const readBody = async req => {
  let raw = ''
  for await (const chunk of req) raw += chunk
  try { return JSON.parse(raw) } catch { return {} }
}

const completion = () => ({
  id: 'chatcmpl-fake',
  object: 'chat.completion',
  created: Math.floor(Date.now() / 1000),
  model: 'fake',
  choices: [{ index: 0, message: { role: 'assistant', content: ANSWER }, finish_reason: 'stop' }],
  usage: { prompt_tokens: 1, completion_tokens: 1, total_tokens: 2 }
})

// Minimal SSE form of the same answer: one content delta, then done
const stream = res => {
  res.writeHead(200, { 'content-type': 'text/event-stream', 'cache-control': 'no-cache', connection: 'keep-alive' })
  const base = { id: 'chatcmpl-fake', object: 'chat.completion.chunk', created: Math.floor(Date.now() / 1000), model: 'fake' }
  res.write(`data: ${JSON.stringify({ ...base, choices: [{ index: 0, delta: { role: 'assistant', content: ANSWER }, finish_reason: null }] })}\n\n`)
  res.write(`data: ${JSON.stringify({ ...base, choices: [{ index: 0, delta: {}, finish_reason: 'stop' }] })}\n\n`)
  res.write('data: [DONE]\n\n')
  res.end()
}

const server = createServer(async (req, res) => {
  // Model listing, which some clients probe on startup
  if (req.method === 'GET' && req.url.includes('/models')) {
    res.writeHead(200, { 'content-type': 'application/json' })
    res.end(JSON.stringify({ object: 'list', data: [{ id: 'fake', object: 'model' }] }))
    return
  }
  if (req.method === 'POST' && req.url.includes('/chat/completions')) {
    const body = await readBody(req)
    const last = (body.messages ?? []).filter(m => m.role === 'user').at(-1)
    process.stderr.write(`fake-llm: prompt=${JSON.stringify(last?.content ?? '')} stream=${!!body.stream}\n`)
    if (body.stream) return stream(res)
    res.writeHead(200, { 'content-type': 'application/json' })
    res.end(JSON.stringify(completion()))
    return
  }
  res.writeHead(404, { 'content-type': 'application/json' })
  res.end(JSON.stringify({ error: { message: `no route for ${req.method} ${req.url}` } }))
})

server.listen(PORT, '0.0.0.0', () => {
  // Print the chosen port so the test runner can read it
  process.stdout.write(`${server.address().port}\n`)
})
