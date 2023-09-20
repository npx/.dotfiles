local M = {}

local setupLsp = function(config)
    return function(server_name)
        require("lspconfig")[server_name].setup(config)
    end
end

local settings = {setupLsp({})}

function M.configure(lspname, config) settings[lspname] = setupLsp(config) end

function M.setup()
    require("mason").setup()
    require("mason-lspconfig").setup()
    require("mason-lspconfig").setup_handlers(settings)
end

return M
