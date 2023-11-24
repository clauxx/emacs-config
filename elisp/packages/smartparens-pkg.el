(use-package evil-cleverparens
  :demand t
  :hook ((clojurescript-mode
	  clojure-mode
	  emacs-lisp-mode
	  cider-repl-mode) . smartparens-strict-mode)
  :hook ((clojurescript-mode
	  clojure-mode
	  emacs-lisp-mode
	  cider-repl-mode) . evil-cleverparens-mode)
  :config
  (sp-local-pair '(emacs-lisp-mode) "'" "'" :actions nil))

(with-eval-after-load 'general
  (general-define-key
   :states 'normal
   :keymaps 'smartparens-mode-map
   :prefix cl/sigma-leader
   "x" '(sp-kill-whole-line :wk "Remove whole line")
   "c" '(sp-kill-sexp :wk "Remove sexp")))

(provide 'smartparens-pkg)
