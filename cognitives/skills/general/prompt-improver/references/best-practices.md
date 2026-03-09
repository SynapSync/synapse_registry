# Claude Prompting Best Practices — Official Reference

Source: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices

## Table of Contents

1. [General Principles](#general-principles)
2. [Output and Formatting](#output-and-formatting)
3. [Tool Use](#tool-use)
4. [Thinking and Reasoning](#thinking-and-reasoning)
5. [Agentic Systems](#agentic-systems)
6. [Capability-Specific Tips](#capability-specific-tips)

---

## General Principles

### Be Clear and Direct

Claude responds well to clear, explicit instructions. Being specific about your desired output enhances results. If you want "above and beyond" behavior, explicitly request it.

**Golden rule:** Show your prompt to a colleague with minimal context. If they'd be confused, Claude will be too.

- Be specific about the desired output format and constraints.
- Provide instructions as sequential steps using numbered lists or bullet points when order or completeness matters.

**Example — Creating an analytics dashboard:**

Less effective:
```
Create an analytics dashboard
```

More effective:
```
Create an analytics dashboard. Include as many relevant features and interactions as possible. Go beyond the basics to create a fully-featured implementation.
```

### Add Context to Improve Performance

Providing context or motivation behind your instructions helps Claude better understand your goals.

**Example — Formatting preferences:**

Less effective:
```
NEVER use ellipses
```

More effective:
```
Your response will be read aloud by a text-to-speech engine, so never use ellipses since the text-to-speech engine will not know how to pronounce them.
```

Claude is smart enough to generalize from the explanation.

### Use Examples Effectively (Few-Shot / Multishot)

Examples are one of the most reliable ways to steer Claude's output format, tone, and structure. 3–5 examples work best.

When adding examples, make them:
- **Relevant:** Mirror your actual use case closely.
- **Diverse:** Cover edge cases and vary enough that Claude doesn't pick up unintended patterns.
- **Structured:** Wrap examples in `<example>` tags (multiple examples in `<examples>` tags).

### Structure Prompts with XML Tags

XML tags help Claude parse complex prompts unambiguously. Wrapping each type of content in its own tag (e.g. `<instructions>`, `<context>`, `<input>`) reduces misinterpretation.

Best practices:
- Use consistent, descriptive tag names across prompts.
- Nest tags when content has a natural hierarchy.

### Give Claude a Role

Setting a role in the system prompt focuses Claude's behavior and tone. Even a single sentence makes a difference:

```
You are a helpful coding assistant specializing in Python.
```

### Long Context Prompting (20K+ tokens)

- **Put longform data at the top**: Place long documents above your query. Queries at the end can improve quality by up to 30%.
- **Structure with XML tags**: Wrap each document in `<document>` tags with `<document_content>` and `<source>` subtags.
- **Ground responses in quotes**: Ask Claude to quote relevant parts before carrying out the task.

---

## Output and Formatting

### Communication Style

Claude's latest models are more direct, conversational, and less verbose. They may skip verbal summaries after tool calls. If you want more visibility:

```
After completing a task that involves tool use, provide a quick summary of the work you've done.
```

### Control Output Format

1. **Tell what to do, not what not to do**
   - Instead of: "Do not use markdown"
   - Try: "Your response should be composed of smoothly flowing prose paragraphs."

2. **Use XML format indicators**
   - "Write the prose sections in `<smoothly_flowing_prose_paragraphs>` tags."

3. **Match prompt style to desired output** — formatting in the prompt influences response style.

4. **Use detailed prompts for specific formatting** — e.g., wrapping formatting guidance in `<avoid_excessive_markdown_and_bullet_points>` tags with detailed rules.

### LaTeX Output

Claude Opus 4.6 defaults to LaTeX for math. If you prefer plain text, add instructions to format with standard text characters.

### Document Creation

For presentations, animations, visual documents:
```
Create a professional presentation on [topic]. Include thoughtful design elements, visual hierarchy, and engaging animations where appropriate.
```

---

## Tool Use

### Be Explicit About Actions

If you say "can you suggest some changes," Claude may only suggest rather than implement. Be explicit:

Less effective:
```
Can you suggest some changes to improve this function?
```

More effective:
```
Change this function to improve its performance.
```

### Proactive vs Conservative Action

For proactive:
```xml
<default_to_action>
By default, implement changes rather than only suggesting them. If the user's intent is unclear, infer the most useful likely action and proceed.
</default_to_action>
```

For conservative:
```xml
<do_not_act_before_instructions>
Do not jump into implementation unless clearly instructed. Default to providing information and recommendations.
</do_not_act_before_instructions>
```

### Parallel Tool Calling

Claude excels at parallel tool execution. Boost to ~100% with:
```xml
<use_parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies, make all independent calls in parallel.
</use_parallel_tool_calls>
```

---

## Thinking and Reasoning

### Avoid Overthinking

Claude Opus 4.6 does significantly more upfront exploration. To control:
- Replace blanket defaults with targeted instructions
- Remove over-prompting (tools that undertriggered before now trigger appropriately)
- Use `effort` parameter as fallback

```
When deciding how to approach a problem, choose an approach and commit to it. Avoid revisiting decisions unless you encounter new information that directly contradicts your reasoning.
```

### Leverage Thinking Capabilities

- Prefer general instructions over prescriptive steps ("think thoroughly" > hand-written step-by-step plan)
- Multishot examples work with thinking — use `<thinking>` tags in examples
- Manual CoT as fallback — use `<thinking>` and `<answer>` tags
- Ask Claude to self-check: "Before you finish, verify your answer against [test criteria]."

---

## Agentic Systems

### Long-Horizon Reasoning

- Use structured formats for state data (JSON for test results, task status)
- Use unstructured text for progress notes
- Use git for state tracking across sessions
- Emphasize incremental progress

### Balancing Autonomy and Safety

```
Consider the reversibility and potential impact of your actions. Take local, reversible actions freely, but for hard-to-reverse or shared-system actions, ask the user first.
```

### Research and Information Gathering

- Provide clear success criteria
- Encourage source verification
- Use structured approach with competing hypotheses and confidence levels

### Subagent Orchestration

- Ensure well-defined subagent tools
- Let Claude orchestrate naturally
- Watch for overuse — add guidance about when subagents are/aren't warranted

### Reduce Overengineering

```
Avoid over-engineering. Only make changes directly requested or clearly necessary. Keep solutions simple and focused.
Don't add features, refactor, or make "improvements" beyond what was asked.
Don't add error handling for scenarios that can't happen.
Don't create abstractions for one-time operations.
```

### Minimize Hallucinations

```xml
<investigate_before_answering>
Never speculate about code you have not opened. Read relevant files BEFORE answering. Give grounded and hallucination-free answers.
</investigate_before_answering>
```

---

## Capability-Specific Tips

### Vision

Give Claude a crop tool or skill to "zoom" in on relevant regions of an image for better performance.

### Frontend Design

Avoid "AI slop" aesthetic. Focus on:
- **Typography**: Distinctive fonts (avoid Arial, Inter, Roboto)
- **Color & Theme**: Cohesive aesthetic with CSS variables, dominant colors with sharp accents
- **Motion**: Animations for effects and micro-interactions
- **Backgrounds**: Atmosphere and depth, not solid colors

Make creative, unexpected choices that feel genuinely designed for the context.
