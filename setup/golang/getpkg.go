// go run getpkg.go
package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"strings"
)

var pkglist = func() string {
	u, err := user.Current()
	if err != nil {
		return "gopkg.list"
	}
	return filepath.Join(u.HomeDir, "dotfiles", "setup", "golang", "gopkg.list")
}()

const template = `
# Comment

golang.org/x/tools/...
github.com/google/gops
github.com/golang/lint/golint
github.com/golang/dep/cmd/dep
`

func main() {
	opt := struct {
		ignoreConfirm bool
		upgrade       bool
		file          string
		dryRun        bool
		template      bool
	}{}
	flag.BoolVar(&opt.ignoreConfirm, "yes", false, "Ignore confirm")
	flag.BoolVar(&opt.ignoreConfirm, "y", false, `Alias of "-yes"`)
	flag.BoolVar(&opt.upgrade, "upgrade", false, "Ignore confirm")
	flag.BoolVar(&opt.upgrade, "u", false, `Alias of "-upgrade"`)
	flag.StringVar(&opt.file, "file", "", fmt.Sprintf("Specify path of package list (default: %q)", pkglist))
	flag.StringVar(&opt.file, "f", "", `Alias of "-file"`)
	flag.BoolVar(&opt.dryRun, "dry-run", false, "Only display target packages")
	flag.BoolVar(&opt.dryRun, "d", false, `Alias of "-dry-run"`)
	flag.BoolVar(&opt.template, "template", false, "Display template of package list")
	flag.BoolVar(&opt.template, "t", false, `Alias of "-template"`)
	flag.Parse()

	if opt.template {
		fmt.Println(template)
		return
	}

	if opt.file != "" {
		pkglist = opt.file
	}

	f, err := os.Open(pkglist)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	var urls []string
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		if err := sc.Err(); err != nil {
			panic(err)
		}
		ss := strings.Fields(sc.Text())
		if len(ss) == 0 {
			continue
		}
		if strings.HasPrefix(ss[0], "#") {
			continue
		}
		urls = append(urls, ss[0])
	}
	if len(urls) == 0 {
		fmt.Printf("package not found in \"%s\"\n", pkglist)
		return
	}

	fmt.Printf("Packages:\n\t%s\n", strings.Join(urls, "\n\t"))

	options := []string{"get", "-v"}
	if opt.upgrade {
		options = append(options, "-u")
	}

	fmt.Printf("Run:\n\t%s %q\n", "go", append(options, "package"))

	if opt.dryRun {
		return
	}

	if !opt.ignoreConfirm {
		fmt.Printf("[yes|no]?> ")
		var stop bool
		func() {
			sc := bufio.NewScanner(os.Stdin)
			for sc.Scan() {
				if err := sc.Err(); err != nil {
					panic(err)
				}
				switch sc.Text() {
				case "y", "yes":
					return
				case "n", "no":
					stop = true
					return
				}
			}
			panic("stdin scan error")
		}()
		if stop == true {
			fmt.Println("stopped")
			return
		}
	}

	for _, url := range urls {
		cmd := exec.Command("go", append(options, url)...)
		cmd.Stderr = os.Stderr
		cmd.Stdout = os.Stdout
		cmd.Stdin = os.Stdin
		if err := cmd.Run(); err != nil {
			panic(err)
		}
	}
}
