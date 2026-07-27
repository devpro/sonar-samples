package main

import (
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/devpro/sonar-samples-go/internal/math"
)

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{"status": "ok"}) //nolint:errcheck
	})

	mux.HandleFunc("GET /greet/{name}", func(w http.ResponseWriter, r *http.Request) {
		name := r.PathValue("name")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{"message": math.Greet(name)}) //nolint:errcheck
	})

	mux.HandleFunc("GET /add/{a}/{b}", func(w http.ResponseWriter, r *http.Request) {
		a, errA := strconv.Atoi(r.PathValue("a"))
		b, errB := strconv.Atoi(r.PathValue("b"))
		if errA != nil || errB != nil {
			http.Error(w, "invalid numbers", http.StatusBadRequest)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]int{"a": a, "b": b, "result": math.Add(a, b)}) //nolint:errcheck
	})

	log.Println("Listening on http://localhost:8080")
	if err := http.ListenAndServe(":8080", mux); err != nil {
		log.Fatal(err)
	}
}
