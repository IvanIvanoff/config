vim.filetype.add({
  extension = {
    -- Used specifically for the .env.dev and .env.prod
    -- files used in Elixir. The autoload of env files looks
    -- for .env.{ENV} and not .{ENV}.env
    env = 'sh',
    dev = 'sh',
    prod = 'sh',
    Jenkinsfile = 'groovy'
  }
})
