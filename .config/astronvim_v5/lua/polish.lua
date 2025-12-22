-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Enable clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Manual clipboard configuration for xclip
vim.g.clipboard = {
  name = 'xclip',
  copy = {
    ['+'] = 'xclip -i -selection clipboard',
    ['*'] = 'xclip -i -selection primary',
  },
  paste = {
    ['+'] = 'timeout 5s xclip -o -selection clipboard 2>/dev/null',
    ['*'] = 'timeout 5s xclip -o -selection primary 2>/dev/null',
  },
  cache_enabled = 0,
}

-- Suppress LSP notifications to prevent "Press ENTER" prompts
vim.lsp.handlers["$/progress"] = function() end
vim.lsp.handlers["window/showMessage"] = function() end
vim.lsp.handlers["window/logMessage"] = function(_, result, ctx)
  -- Only show ERROR level logs (type 1), suppress WARN/INFO
  if result.type == 1 then
    vim.notify(result.message, vim.log.levels.ERROR)
  end
end

-- Prevent hit-enter prompts from long messages
vim.opt.shortmess:append("c")  -- Don't show completion messages
vim.opt.shortmess:append("t")  -- Truncate messages to avoid prompts
