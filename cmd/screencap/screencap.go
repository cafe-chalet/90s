package main

import (
	"github.com/go-rod/rod"
	"github.com/go-rod/rod/lib/launcher"
)

func main() {
	u := launcher.New().
		Set("--no-sandbox").
		MustLaunch()
	page := rod.New().ControlURL(u).MustConnect().MustPage("https://www.wikipedia.org/")
	page.MustWaitStable().MustScreenshot("a.png")
}
