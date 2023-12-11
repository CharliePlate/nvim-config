local function map(params)
	local opts = { noremap = true, silent = true }

	if type(params[4]) ~= "table" then
		params[4] = opts
	else
		params[4] = vim.tbl_extend("force", params[4], opts)
	end

	vim.keymap.set(params[1], params[2], params[3], params[4])
end

map({ "n", "<esc>", ":noh<cr>" })

-- Recenter after scrolling
map({ "n", "<c-f>", "<c-f>zz" })
map({ "n", "<c-d>", "<c-d>zz" })
map({ "n", "<c-u>", "<c-u>zz" })
map({ "n", "<c-b>", "<c-b>zz" })

local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

map({ "n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" } })
map({ "n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" } })
map({ "n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" } })
map({ "n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" } })
map({ "n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" } })
map({ "n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" } })
map({ "n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" } })

-- jk to move right quickly
map({ "i", "jk", "<c-o>a" })

map({ "n", "<leader>lr", ":IncRename " .. vim.fn.expand("<cword>") })
