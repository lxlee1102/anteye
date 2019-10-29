package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/lxlee1102/anteye/g"
	"github.com/lxlee1102/anteye/http"
	"github.com/lxlee1102/anteye/monitor"
)

func main() {
	cfg := flag.String("c", "cfg.json", "configuration file")
	version := flag.Bool("v", false, "version")
	flag.Parse()

	if *version {
		fmt.Println(g.VERSION)
		os.Exit(0)
	}

	// global config
	g.ParseConfig(*cfg)

	// monitor
	monitor.Start()

	// http
	http.Start()

	select {}
}
