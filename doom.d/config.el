;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Antoine Laurent"
      user-mail-address "alaurent@agencemobilitedurable.ca")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Display

;; Allow mixed fonts in a buffer. This is particularly useful for Org mode,
;; so I can mix source and prose blocks in the same document. I also manually
;; enable solaire-mode in Org mode as a workaround for font scaling not 
;; working properly.

(add-hook! 'org-mode-hook #'mixed-pitch-mode)
;;(add-hook! 'org-mode-hook #'solaire-mojde)
(setq mixed-pitch-variable-pitch-cursor nil)


(setq doom-theme 'spacemacs-light)

(custom-set-faces!
  '(doom-dashboard-banner :inherit default)
  '(doom-dashboard-loaded :inherit default))
;;(setq spacemacs-theme-comment-bg nil)

;; Truncate lines in ivy childframes
;; (setq posframe-arghandler
;;       (lambda (buffer-or-name key value)
;;         (or (and (eq key :lines-truncate)
;;                  (equal ivy-posframe-buffer
;;                         (if (stringp buffer-or-name)
;;                             buffer-or-name
;;                           (buffer-name buffer-or-name)))
;;                  t)
;;             value)))

;; word count
(setq doom-modeline-enable-word-count t)

;; Variables paths
(setq al/local-root
      (if (string-equal system-type "windows-nt")
          "C:/Users/alaurent"
        "~/"))
(setq al/org-dir (expand-file-name "org" al/local-root))
;;(setq al/org-brain-path (expand-file-name "brain" al/org-dir))
(setq al/projects (expand-file-name "repos" al/local-root))

;; Org mode
(after! org
  (add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))
  (setq org-todo-keywords
        '((sequence "TODO(t!)" "TODAY(a!)" "NEXT(n!)" "STARTED(s!)" "IN-PROGRESS(p!)" "UNDERWAY(u!)" "WAITING(w@)" "SOMEDAY(o!)" "MAYBE(m!)" "|" "DONE(d@)" "CANCELED(c@)")
          (sequence "CHECK(k!)" "|" "DONE(d@)")
          (sequence "TO-READ(r!)" "READING(R!)" "|" "HAVE-READ(d@)")
          (sequence "TO-WATCH(!)" "WATCHING(!)" "SEEN(!)")))
  (setq org-imenu-depth 7)
  (setq org-ellipsis " ▾ ")
  (setq org-superstar-headline-bullets-list '("⁖"))
  ;;(add-hook! 'org-mode-hook #'mixed-pitch-mode)
  ;;(add-hook! 'org-mode-hook #'olivetti-mode)
  (setq org-babel-python-command "python3")
  (setq org-cycle-separator-lines 1)
  (setq org-edit-src-content-indentation 0)
  (setq org-export-initial-scope 'subtree)
  (setq org-image-actual-width 400)
  (setq org-src-window-setup 'current-window)
  (setq org-startup-indented t)
  (setq org-log-done t)
  (setq org-log-into-drawer t))

;; remove completion when writting
(defun al/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
(add-hook! org-mode (al/adjust-org-company-backends))
(add-hook! markdown-mode (al/adjust-org-company-backends))

(add-hook! org-mode :append
           #'visual-line-mode
           #'variable-pitch-mode)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory al/org-dir
      ;; I'm not sure how to use this
      ;; org-id-locations-file (expand-file-name ".orgids" al/org-dir)
      ;; org-id-locations-file-relative t
      org-roam-directory (expand-file-name "roam" al/org-dir))

(setq org-agenda-files (list al/org-dir))

(after! org-capture
  (setq org-capture-templates
        '(("b" "Basic task for future review" entry
           (file+headline "tasks.org" "Basic tasks that need to be reviewed")
           "* %^{Title}\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%l"
           :empty-lines 1)

          ("w" "Work")
          ("wt" "Task or assignment" entry
           (file+headline "work.org" "Tasks and assignments")
           "\n\n* TODO [#A] %^{Title} :@work:\nSCHEDULED: %^t\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?"
           :empty-lines 1)

          ("wm" "Meeting, event, appointment" entry
           (file+headline "work.org" "Meetings, events, and appointments")
           "\n\n* MEET [#A] %^{Title} :@work:\nSCHEDULED: %^T\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?"
           :empty-lines 1)

          ("t" "Task with a due date" entry
           (file+headline "tasks.org" "Task list with a date")
           "\n\n* %^{Scope of task||TODO|STUDY|MEET} %^{Title} %^g\nSCHEDULED: %^t\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?"
           :empty-lines 1)

          ("j" "Journal" entry
           (file+olp+datetree "journal.org")
           "* %?\n"
           :empty-lines 1))))

(after! org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "all-posts.org" "Blog Ideas")
                 (function org-hugo-new-subtree-post-capture-template))))

(use-package org-web-tools
  :commands org-web-tools-insert-link-for-url)

(after! org-roam

  (defun my/org-roam-project-finalize-hook ()
    "Adds the captured project file to `org-agenda-files' if the
capture was not aborted."
    ;; Remove the hook since it was added temporarily
    (remove-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)

    ;; Add project file to the agenda list if the capture was confirmed
    (unless org-note-abort
      (with-current-buffer (org-capture-get :buffer)
        (add-to-list 'org-agenda-files (buffer-file-name)))))

  (defun my/org-roam-find-project ()
    (interactive)
    ;; Add the project file to the agenda after capture is finished
    (add-hook 'org-capture-after-finalize-hook #'my/org-roam-project-finalize-hook)

    ;; Select a project file to open, creating it if necessary
    (org-roam-node-find
     nil
     nil
     (my/org-roam-filter-by-tag "Project")
     :templates
     '(("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
        :unnarrowed t))))

  (defun my/org-roam-capture-inbox ()
    (interactive)
    (org-roam-capture- :node (org-roam-node-create)
                       :templates '(("i" "inbox" plain "* %?"
                                     :if-new (file+head "Inbox.org" "#+title: Inbox\n")))))

  (defun my/org-roam-copy-todo-to-today ()
    (interactive)
    (let ((org-refile-keep t) ;; Set this to nil to delete the original!
          (org-roam-dailies-capture-templates
           '(("t" "tasks" entry "%?"
              :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
          (org-after-refile-insert-hook #'save-buffer)
          today-file
          pos)
      (save-window-excursion
        (org-roam-dailies--capture (current-time) t)
        (setq today-file (buffer-file-name))
        (setq pos (point)))

      ;; Only refile if the target file is different than the current file
      (unless (equal (file-truename today-file)
                     (file-truename (buffer-file-name)))
        (org-refile nil nil (list "Tasks" today-file nil pos)))))
  )

(after! org-agenda
  ;; (setq org-agenda-prefix-format
  ;;       '((agenda . " %i %-12:c%?-12t% s")
  ;;         ;; Indent todo items by level to show nesting
  ;;         (todo . " %i %-12:c%l")
  ;;         (tags . " %i %-12:c")
  ;;        (search . " %i %-12:c")))
  (setq org-agenda-include-diary t))

(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-groups '((:auto-dir-name t)))
  (org-super-agenda-mode))

(use-package! org-archive
  :after org
  :config
  (setq org-archive-location "archive.org::datetree/"))

(after! org-clock
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate))

(after! ox-hugo
  (setq org-hugo-use-code-for-kbd t))

(defun zz/org-reformat-buffer ()
  (interactive)
  (when (y-or-n-p "Really format current buffer? ")
    (let ((document (org-element-interpret-data (org-element-parse-buffer))))
      (erase-buffer)
      (insert document)
      (goto-char (point-min)))))

(use-package org-pandoc-import)

(after! dap-mode
  (setq dap-python-debugger 'debugpy))

;; Narrow buffer
(use-package! olivetti
  :config
  (setq-default olivetti-body-width 130)
  (add-hook 'mixed-pitch-mode-hook  (lambda () (setq-local olivetti-body-width 80))))

(use-package! auto-olivetti
  :custom
  (auto-olivetti-enabled-modes '(text-mode helpful-mode ibuffer-mode image-mode)) ;;prog-mode
  :config
  (auto-olivetti-mode))

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (awk . t)
     (calc .t)
     (C . t)
     (emacs-lisp . t)
     (haskell . t)
     (gnuplot . t)
     (latex . t)
     ;;(ledger . t)
     (js . t)
     (haskell . t)
     (http . t)
     (perl . t)
     (python . t)
     (gnuplot . t)
     ;; org-babel does not currently support php.  That is really sad.
     ;;(php . t)
     (R . t)
     (scheme . t)
     (sh . t)
     (sql . t)
     ;;(sqlite . t)
     )))
(use-package! org
  :config
  (require 'org-tempo)

  ;; extra languages for src blocks
  (pushnew! org-structure-template-alist
            '("el" . "src emacs-lisp")
            '("js" . "src javascript")
            '("lu" . "src lua")
            '("py" . "src python")
            '("sh" . "src shell")
            '("ya" . "src yaml"))

  ;; extra org structure templates
  (pushnew! org-src-lang-modes
            '("conf-unix" . conf-unix)
            '("toml"      . conf-toml)))

(after! numpydoc
  (setq jnumpydoc-insertion-style nil))

(after! magit
  (setq magit-diff-hide-trailing-cr-characters t))

;; (use-package! org-transclusion)

;; (after! projectile
;;   (dolist (project al/projects)
;;     (projectile-add-known-project project)))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq doom-leader-key ","
      doom-localleader-key "\\")
