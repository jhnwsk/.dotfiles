-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Enable clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Manual clipboard configuration for xclip
vim.g.clipboard = {
  name = 'xclip',
  copy = {
    ['+'] = 'timeout 1s xclip -quiet -i -selection clipboard',
    ['*'] = 'timeout 1s xclip -quiet -i -selection primary',
  },
  paste = {
    ['+'] = 'timeout 1s xclip -o -selection clipboard',
    ['*'] = 'timeout 1s xclip -o -selection primary',
  },
  cache_enabled = 1,
}
