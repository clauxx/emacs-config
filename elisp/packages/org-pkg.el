(setq org-directory "~/org"
      org-default-notes-file (concat org-directory "/tasks.org")
      org-agenda-files '("~/org")
      org-archive-location "basement::** Finished Tasks"
      org-edit-src-content-indentation 0
      org-adapt-indentation t
      org-return-follows-link t
      calendar-week-start-day 1
      electric-indent-mode t

      ;; Edit settings
      org-auto-align-tags t
      org-tags-column 0
      org-catch-invisible-edits 'show-and-error
      ;;org-special-ctrl-a/e t
      ;;org-insert-heading-respect-content t

      ;; Org styling, hide markup etc.
      ;;org-pretty-entities t
      org-agenda-prefix-format '((agenda . "☐ %i %?-12t% s"))

      ;; Agenda styling
      org-agenda-span 14
      org-agenda-start-day "-3d"
      org-agenda-tags-column 0
      org-agenda-block-separator ?─
      org-agenda-time-grid
      '((daily today require-timed)
	(800 1000 1200 1400 1600 1800 2000)
	" ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
      org-agenda-current-time-string
      "◀── now ─────────────────────────────────────────────────"
      org-ellipsis "…"

      ;; Org Capture Templates
      org-capture-templates
      '(("t" "TODO" entry (file+headline org-default-notes-file "Tasks")
	 "* TODO %? %^G \n  %U")
	("s" "Scheduled TODO" entry (file+headline org-default-notes-file "Tasks")
	 "* TODO %? %^G \nSCHEDULED: %^t\n  %U")
	("d" "Deadline" entry (file+headline org-default-notes-file "Tasks")
	 "* TODO %? %^G \n  DEADLINE: %^t")
	("i" "Idea" entry (file+headline org-default-notes-file "Ideas")
	 "* %? %^G")
	("a" "Appointment" entry (file+headline org-default-notes-file "Appointments")
	 "* %? %^G \n  %^t")))

;; NOTE: updating the "DONE" todos face whenever 
(defface done_mask '((t (:foreground "gray" :strike-through "red"))) nil)
(add-hook 'org-after-todo-state-change-hook
	  (lambda ()
	    (highlight-regexp " DONE .+" 'done_mask)
	    (run-at-time "0.0 sec" nil (lambda ()
					 (org-agenda-redo)))))

(custom-set-faces
 '(org-agenda-date-weekend ((t (:background "gray70" :foreground "black" :slant italic))))
 '(org-agenda-date ((t (:background "gray80" :foreground "black" :font-size 18))))
 '(org-agenda-date-today ((t (:background "lemon chiffon" :foreground "black" :weight bold)))))

(use-package deft
  :commands (deft)
  :config
  (setq deft-directory "~/org"
        deft-recursive t
        deft-extensions '("md" "org")))

(use-package evil-org
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook (lambda ()
				  (evil-org-set-key-theme
				   '(textobjects insert navigation additional shift todo heading))))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-modern
  :config
  (global-org-modern-mode))

(use-package org-super-agenda
  :config
  (org-super-agenda-mode t))

;; | Typing the below + TAB | Expands to ...                          |
;; |------------------------+-----------------------------------------|
;; | <a                     | '#+BEGIN_EXPORT ascii' … '#+END_EXPORT  |
;; | <c                     | '#+BEGIN_CENTER' … '#+END_CENTER'       |
;; | <C                     | '#+BEGIN_COMMENT' … '#+END_COMMENT'     |
;; | <e                     | '#+BEGIN_EXAMPLE' … '#+END_EXAMPLE'     |
;; | <E                     | '#+BEGIN_EXPORT' … '#+END_EXPORT'       |
;; | <h                     | '#+BEGIN_EXPORT html' … '#+END_EXPORT'  |
;; | <l                     | '#+BEGIN_EXPORT latex' … '#+END_EXPORT' |
;; | <q                     | '#+BEGIN_QUOTE' … '#+END_QUOTE'         |
;; | <s                     | '#+BEGIN_SRC' … '#+END_SRC'             |
;; | <v                     | '#+BEGIN_VERSE' … '#+END_VERSE'         |
(require 'org-tempo)

(provide 'org-pkg)
