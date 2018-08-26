(asdf:defsystem #:nlgame
  :description "Describe nlgame here"
  :author "Nikhilesh Sigatapu <s.nikhilesh@gmail.com>"
  :license "MIT"
  :depends-on (#:cffi
               #:cl-opengl #:sdl2 #:png-read
               #:swank)
  :serial t
  :components ((:file "package")

               (:file "repl")
               (:file "main")))

