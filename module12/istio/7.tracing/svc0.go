package svc0

import (
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	"github.com/golang/glog"
)

func rootHandler(w http.ResponseWriter, r *http.Request) {
	glog.V(4).Info("entering v2 root handler")

	delay := randInt(10, 20)
	time.Sleep(time.Millisecond * time.Duration(delay))
	io.WriteString(w, "========================Details of the http request header: =========")

	// client config
	req, err := http.NewRequest("GET", "http://service1", nil)
	if err != nil {
		fmt.Printf("%s", err)
	}

	lowerCaseHeader := make(http.Header)
	for key, value := range r.Header {
		lowerCaseHeader[strings.ToLower(key)] = value
	}
	glog.Info("headers", lowerCaseHeader)
	req.Header = lowerCaseHeader

	// client(svc0) -> server(svc1)
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		glog.Info("HTTP get failed with error: ", "error", err)
	} else {
		glog.Info("HTTP get successed")
	}
	if resp != nil {
		resp.Write(w)
	}
	glog.V(4).Info("Response in %d ms", delay)

}
