package main

import (
    "fmt"
    "net/http"
)

func viewHandler(w http.ResponseWriter, r *http.Request) {
    title := r.URL.Path[len("/view/"):]
    fmt.Fprintf(w, "<h1>%s</h1><div>%s</div>", title , "Rangito3")
}

func main() {
    http.HandleFunc("/view/", viewHandler)
    http.ListenAndServe(":8080", nil)
}
