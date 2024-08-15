(defun cl/open-config ()
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(defun cl/reload-config ()
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory)))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual)
   :keymaps '(override cl/keys-mode-map)
   "f" '(execute-extended-command :wk "Execute command")
   "." '(find-file :wk "Find in current dir"))

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "SPC"  '(project-find-file :wk "Search")
   "c"    '(kill-this-buffer :wk "Kill this buffer"))
  
  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "f" '(:ignore t :wk "Find")
   "f ." '(find-file :wk "Find current dir"))

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "a" '(:ignore t :wk "Agenda")
   "a a" '(org-agenda :wk "Show agenda")
   "a c" '(org-capture :wk "Capture")
   "a f" '(org-capture-finalize :wk "Finalize capture"))

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "p"   '(:ignore t :wk "Project")
   "p p" '(project-switch-project :wk "Switch project"))

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "o" '(:ignore t :wk "Open")
   "o s" '(project-shell :wk "Open shell in project")
   "o c" '(cl/open-config :wk "Open emacs config")
   "o r" '(cl/reload-config :wk "Reload emacs config"))

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/beta-leader
   "c" '(kill-this-buffer :wk "Kill this buffer")
   "j" '(next-buffer :wk "Next buffer")
   "k" '(previous-buffer :wk "Previous buffer")
   "r" '(revert-buffer :wk "Reload buffer")))

(provide 'keybindings)
