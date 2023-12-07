local M = {}

-- stylua: ignore
M.keys = {
  { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
  { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
  { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
  { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
  { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
}

M.set_binds = function(_, buffer)
	local opts = { noremap = true, silent = true }
	local whichkey = require("which-key")
	whichkey.register({ ["<leader>c"] = { name = "+coding" } }, { buffer = buffer })
	for _, key in pairs(M.keys) do
		vim.keymap.set(key.mode or "n", key[1], key[2], opts)
		whichkey.register({ [key[1]] = { name = key["desc"] } }, { buffer = buffer })
	end
end

return M
