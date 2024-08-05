(use-package consult
  :ensure t
  :demand t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(defun cl/find-symbol-at-point ()
  "Search for the symbol at point using consult-ripgrep.
   If no project is found, search in the user's home directory."
  (interactive)
  (let ((symbol (thing-at-point 'symbol))
        (search-dir (if (project-current)
                        (project-root (project-current))
                      (expand-file-name "~"))))
    (if symbol
        (consult-ripgrep search-dir symbol)
      (message "No symbol at point."))))

(defun cl/find-in-current-dir ()
  (interactive)
  (consult-ripgrep default-directory))

(with-eval-after-load 'general
  (general-define-key
   :states 'normal
   :keymaps 'corfu-mode-map
   "C-p" 'consult-yank-pop)

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/beta-leader
   "S-SPC" '(consult-project-buffer :wk "Switch project buffer")
   "SPC" '(consult-buffer :wk "Switch buffer (all)"))

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "f f" '(consult-ripgrep :wk "Find by word (project)")
   "f i" '(consult-imenu :wk "Find symbols (imenu)")
   "f r" '(consult-recent-file :wk "Find recent")
   "f a" '(consult-org-agenda :wk "Find agenda items")
   "f F" '(cl/find-in-current-dir :wk "Find by word (current location)")
   "f c" '(cl/find-symbol-at-point :wk "Find at cursor")))

(provide 'consult-pkg)
