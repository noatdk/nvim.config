return {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
  config = function()
    local run_term_id = vim.g.run_term_id or 99
    local fidget = require 'fidget'
    local toggleterm = require 'toggleterm.terminal'
    require('toggleterm').setup {
      lazy = true,
      open_mapping = { [[<c-t>]], [[<c-¥>]] },
      -- shell = "bash",
      on_stdout = function(t, job, data, name)
        local efm = vim.opt.errorformat._value
        if t.id == run_term_id then
          -- new array
          local new_data = {}
          for i, line in pairs(data) do
            if line ~= '' then
              new_data[#new_data + 1] = line
            end
          end
          vim.fn.setqflist({}, ' ', { lines = new_data, efm = efm })
        end
      end,
    }
    vim.keymap.set('n', '<leader>tr', function()
      -- find ".ttermrun" in the working directory for cmd to run
      -- local cwd = vim.fn.getcwd()
      local cmd = vim.opt.makeprg._value
      if cmd == 'make' then
        -- if vim.fn.filereadable(ttermrun) == 1 then
        --   cmd = vim.fn.readfile(ttermrun)[1]
        -- else
        fidget.notify('No run config is found (default makeprg)', vim.log.levels.WARN)
      end

      -- tries to find toggleterm with id 99 (arbitrarily high number)
      -- if it exists, sends SIGINT/2 (interrupt) to the first child process
      -- if not, creates a new terminal with the same id
      local term = toggleterm.get(run_term_id, true)
      if term ~= nil then
        local jobpid = vim.fn.jobpid(term.job_id)
        local termchildren = vim.api.nvim_get_proc_children(jobpid)
        if next(termchildren) ~= nil then
          vim.system { 'kill', '-2', '-' .. termchildren[1] }
        end
      else
        term = toggleterm.Terminal:new { id = run_term_id, display_name = 'RUN' }
        term:spawn()
        term:open()
      end
      if term ~= nil then
        fidget.notify('Running: ' .. cmd, vim.log.levels.INFO)
        term:send(cmd, true)
      else
        fidget.notify('Failed to create terminal', vim.log.levels.ERROR)
        return
      end
    end, { desc = 'Make [T]oggleterm [R]un' })
  end,
}
