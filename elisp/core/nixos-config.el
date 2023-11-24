(defun cl/sudo-shell-command (command)
  (interactive "MShell command (root): ")
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

(defun cl/nixos-rebuild ()
  (interactive)
  (sudo-shell-command "sudo nixos-rebuild switch"))

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

(provide 'nixos-config)
