(use-package evil
  :demand t
  :ensure t
  :init (setq evil-want-integration t
	      evil-want-keybinding nil
	      evil-vsplit-window-right t
	      evil-split-window-below t
	      evil-set-undo-system 'undo-redo
	      evil-inhibit-esc nil)
  :config
  (evil-set-initial-state 'minibuffer-mode 'emacs)
  (evil-mode +1))

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "RET") nil))

(use-package evil-collection
  :demand t
  :after evil
  :init 
  (setq evil-collection-mode-list
	'(dashboard
	  dired
	  ibuffer
	  magit
	  eshell
	  calendar))
  :config
  (evil-collection-init))

(use-package evil-commentary 
  :demand t
  :ensure t
  :after evil
  :config
  (evil-commentary-mode))

(with-eval-after-load 'general
  (general-define-key
   :states ''motion
   :keymaps 'emacs-lisp-mode-map
   "C-j" '(evil-scroll-line-up :wk "Scroll up")
   "C-k" '(evil-scroll-line-down :wk "Scroll down")
   "." '(find-file :wk "Find in current dir"))

  (general-define-key
   :states '(normal visual emacs)
   :keymaps 'cl/keys-mode-map
   :prefix cl/leader
   "w"    '(:ignore t :wk "Windows")
   "w c"  '(evil-window-delete :wk "Close window")
   "w \\" '(evil-window-vsplit :wk "Vertical split window")
   "w |"  '(evil-window-split :wk "Horizontal split window")
   "w h"  '(evil-window-left :wk "Window left")
   "w j"  '(evil-window-down :wk "Window down")
   "w k"  '(evil-window-up :wk "Window up")
   "w l"  '(evil-window-right :wk "Window right")
   "w w"  '(evil-window-next :wk "Goto next window")))

(provide 'evil-pkg)
