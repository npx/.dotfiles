-- lua_ls: Lua Language Server (for Neovim config development)
return {
  settings = {
    Lua = {
      diagnostics = {
        -- Recognize 'vim' as a global variable
        globals = { "vim" }
      }
    }
  }
}
