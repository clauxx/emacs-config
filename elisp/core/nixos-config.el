(defun cl/sudo-shell-command (command) (interactive "MShell command (root): ")
       (with-temp-buffer
	 (cd "/sudo::/")
	 (async-shell-command command)))

(defun cl/project-nix-shell-command (command &optional name)
  (interactive "MAsync shell command: \nsBuffer name (*Async Shell Command*): ")
  (let ((output-buffer (or name "*Async Shell Command*"))
        (project-root (car (last (project-current))))) ; using project.el
    (message project-root)
    (if project-root
        (let ((default-directory project-root))
          (shell-command (concat "nix-shell --run " "'" command "'") output-buffer))
      (message "Not in a project directory."))))

(defun cl/project-eshell-new-instance ()
  "Open a new Eshell instance with project-eshell in the current project's directory."
  (interactive)
  (let ((current-prefix-arg '(4)))  ;; Simulate C-u prefix argument
    (call-interactively 'project-eshell)))

(defun cl/project-nix-eshell (shell)
  (let ((project-dir (if (project-current)
                         (project-root (project-current))
                       default-directory)))
    (if (file-exists-p (concat project-dir "shell.nix"))
	(progn
	  (split-window-below)
	  (other-window 1)
	  (shell)
          (insert "nix-shell")
          (eshell-send-input))
      (message "No `shell.nix` found in project root!"))))

(defun cl/nixos-rebuild ()
  (interactive)
  (cl/sudo-shell-command "sudo nixos-rebuild switch"))

(defun cl/home-manager-rebuild ()
  (interactive)
  (shell-command "home-manager switch"))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "n"   '(:ignore t :wk "NixOS helpers")
   "n n" '(cl/nixos-rebuild :wk "Rebuild NixOS")
   "n h" '(cl/home-manager-rebuild :wk "Rebuild Home Manager")))

(with-eval-after-load 'general
  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "o N"   '((lambda () (interactive) (cl/project-nix-eshell 'cl/project-eshell-new-instance)) :wk "Open new project nix-shell (if there)")
   "o n"   '((lambda () (interactive) (cl/project-nix-eshell 'project-eshell)) :wk "(Re-)open project nix-shell (if there)")))

(provide 'nixos-config)
