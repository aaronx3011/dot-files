vim.g.mapleader = " "
vim.keymap.set("n", "<C-n>", vim.cmd.noh)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "<leader>y", '"+y')

vim.keymap.set("n", "<leader>p", '"*p', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>P", '"*P', { noremap = true, silent = true })

vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.cursorline = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true




USER = os.getenv("USER")
UNDODIR = "/home/" .. USER .. "/nvim/undo/"


if vim.fn.isdirectory(UNDODIR) == 0 then
	vim.fn.mkdir(UNDODIR, "p", "0o700")
end



vim.opt.undodir = UNDODIR

vim.opt.undofile = true
