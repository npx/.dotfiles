return {
    "robitx/gp.nvim",
    config = function()
        require("gp").setup({
            openai_api_key = {"cat", "~/.gpt4"},
            agents = {
                {
                    name = "ChatGPT4",
                    chat = true,
                    command = false,
                    -- string with model name or table with model name and parameters
                    model = {model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1},
                    -- system prompt (use this to specify the persona/role of the AI)
                    system_prompt = "You are a general AI assistant.\n\n" ..
                        "The user provided the additional info about how they would like you to respond:\n\n" ..
                        "- If you're unsure don't guess and say you don't know instead.\n" ..
                        "- Ask question if you need clarification to provide better answer.\n" ..
                        "- Think deeply and carefully from first principles step by step.\n" ..
                        "- Zoom out first to see the big picture and then zoom in to details.\n" ..
                        "- Use Socratic method to improve your thinking and coding skills.\n" ..
                        "- Don't elide any code from your output if the answer requires coding.\n" ..
                        "- Take a deep breath; You've got this!\n"
                }, {
                    name = "RefactorTS",
                    chat = false,
                    command = true,
                    -- string with model name or table with model name and parameters
                    model = {model = "gpt-4-turbo", temperature = 0.1, top_p = 1},
                    -- system prompt (use this to specify the persona/role of the AI)
                    system_prompt = "You are an experienced senior TypeScript developer.\n\n" ..
                        "Your job is to carefully follow the given instructions to refactor TypeScript code.\n" ..
                        "Output code only and do not speak directly to me, omitting any additional text or instructions.\n"
                }, {
                    name = "CodeGPT4",
                    chat = false,
                    command = true,
                    -- string with model name or table with model name and parameters
                    model = {model = "gpt-4-1106-preview", temperature = 0.8, top_p = 1},
                    -- system prompt (use this to specify the persona/role of the AI)
                    system_prompt = "You are an AI working as a code editor.\n\n" ..
                        "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n" ..
                        "START AND END YOUR ANSWER WITH:\n\n```"
                }
            }
        })
    end
}
