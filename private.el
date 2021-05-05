;; private configuration in additon to nano.el

;; User name
(setq user-full-name "voidfoo")

;; User mail address
(setq user-mail-address "void.foo@gamil.com")

(menu-bar-mode -1)

;; allow M-SPC as a prefix
(global-set-key (kbd "M-SPC") nil)
(global-set-key (kbd "M-SPC g l") nil)

(global-set-key (kbd "M-SPC b d")    'kill-this-buffer)
(global-set-key (kbd "M-o")     'other-window)

;; hippie-expand
(global-set-key [(meta ?/)] 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(defalias 'yes-or-no-p 'y-or-n-p)

;; use locally cached packages from the other configuration
(let ((default-directory  "C:/Users/myumyu.000/.tryout/elpa"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'use-package)

(use-package which-key
  :config
  (which-key-mode 1)
  :ensure t)

(use-package ibuffer
  :bind
  (("C-x C-b" . ibuffer))
  :config
  (setq ibuffer-formats
        '((mark modified read-only " " (name 16 16) " "
                (size 9 -1 :right) " " (mode 16 16 :left :elide)
                " " (process 8 -1) " " filename)
          (mark " " (name 16 -1) " " filename))
        ;; ibuffer-elide-long-columns t
        ibuffer-eliding-string "&"))

(use-package counsel
  :ensure t
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 20)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-display-style 'fancy)
  (setq ivy-format-function 'ivy-format-function-line) ; Make highlight extend all the way to the right
  ;; TODO testing out the fuzzy search
  (setq ivy-re-builders-alist
        '((counsel-M-x . ivy--regex-fuzzy) ; Only counsel-M-x use flx fuzzy search
                  (t . ivy--regex-plus)))
  (setq enable-recursive-minibuffers t)
  :bind
  ("M-SPC s s" . swiper)
  ("M-SPC s r" . counsel-rg)
  ("M-SPC f f" . counsel-file-jump)
  ("M-x" . counsel-M-x)
  ("C-x b" . ivy-switch-buffer)
  ("M-SPC b b" . ivy-switch-buffer)
  ("<f1> f" . 'counsel-describe-function)
  ("<f1> v" . 'counsel-describe-variable)
  ("<f1> l" . 'counsel-find-library)
  ("<f2> i" . 'counsel-info-lookup-symbol)
  ("<f2> u" . 'counsel-unicode-char)
  :diminish (counsel-mode . ""))
(counsel-mode t)

(use-package expand-region
  :bind
  ("M-SPC v" . er/expand-region)
  :config
  (setq expand-region-contract-fast-key "V")
  :ensure t)

(use-package move-text
  :ensure t
  :bind
  (([(meta up)] . move-text-up)
   ([(meta down)] . move-text-down)))


(use-package projectile
  :diminish projectile-mode
  :init
  (setq projectile-completion-system 'ivy
        projectile-indexing-method 'alien)
  :bind-keymap
  ("M-SPC p" . projectile-command-map)
  :config
  (projectile-mode 1)
  :ensure t)

(use-package magit
  :defer t
  :ensure t
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :bind
  (("M-SPC g s" . magit-status)
   ("M-SPC g c" . magit-clone)
   ("M-SPC g f f" . magit-find-file)
   ("M-SPC g f l" . magit-log-buffer-file)
   ("M-SPC g f d" . magit-diff)
   ("M-SPC g m" . magit-dispatch)
   ("M-SPC g S" . magit-stage-file)
   ("M-SPC g U" . magit-unstage-file))
  :commands magit-status)

(use-package git-timemachine
  :ensure t
  :bind
  (("M-SPC g t" . git-timemachine))
  :defer t)

(use-package git-messenger
  :ensure t
  :bind
  (("M-SPC g M" . git-messenger:popup-message)))

;; git-link configs from spacemacs
(defun spacemacs/git-link-copy-url-only ()
  "Only copy the generated link to the kill ring."
  (interactive)
  (let (git-link-open-in-browser)
    (call-interactively 'spacemacs/git-link)))

(defun spacemacs/git-link-commit-copy-url-only ()
  "Only copy the generated link to the kill ring."
  (interactive)
  (let (git-link-open-in-browser)
    (call-interactively 'spacemacs/git-link-commit)))

(defun spacemacs/git-link ()
  "Allow the user to run git-link in a git-timemachine buffer."
  (interactive)
  (require 'git-link)
  (if (and (boundp 'git-timemachine-revision)
           git-timemachine-revision)
      (cl-letf (((symbol-function 'git-link--branch)
                 (lambda ()
                   (car git-timemachine-revision))))
        (call-interactively 'git-link))
    (call-interactively 'git-link)))

(defun spacemacs/git-link-commit ()
  "Allow the user to run git-link-commit in a git-timemachine buffer."
  (interactive)
  (require 'git-link)
  (if (and (boundp 'git-timemachine-revision)
           git-timemachine-revision)
      (cl-letf (((symbol-function 'word-at-point)
                 (lambda ()
                   (car git-timemachine-revision))))
        (call-interactively 'git-link-commit))
    (call-interactively 'git-link-commit)))

(use-package git-link
  :ensure t
  :config
  (setq git-link-default-branch "master"
        git-link-default-remote "upstream")
  :bind
  (("M-SPC g l l" . spacemacs/git-link)
   ("M-SPC g l c" . spacemacs/git-link-commit)
   ("M-SPC g l L" . spacemacs/git-link-copy-url-only)
   ("M-SPC g l C" . spacemacs/git-link-commit-copy-url-only)))
