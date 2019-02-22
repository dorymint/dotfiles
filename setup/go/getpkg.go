// go run getpkg.go
package main

import (
	"bufio"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"strings"
)

const template = `
# Comment

golang.org/x/tools/...
github.com/google/gops
github.com/golang/lint/golint
github.com/golang/dep/cmd/dep
`

// hard code
var DefaultPackageList = func() string {
	u, err := user.Current()
	if err != nil {
		panic(err)
	} else if u.HomeDir == "" {
		panic("not defined: u.HomeDir")
	}
	return filepath.Join(u.HomeDir, "dotfiles", "setup", "go", "gopkg.list")
}()

var opt struct {
	file          string
	upgrade       bool
	ignoreConfirm bool
	dryrun        bool
	template      bool
}

func init() {
	flag.StringVar(&opt.file, "file", DefaultPackageList, "Specify path of package list")
	flag.StringVar(&opt.file, "f", DefaultPackageList, `Alias of "-file"`)
	flag.BoolVar(&opt.upgrade, "upgrade", false, "Install and Upgrade binaries")
	flag.BoolVar(&opt.upgrade, "u", false, `Alias of "-upgrade"`)
	flag.BoolVar(&opt.ignoreConfirm, "yes", false, "Ignore confirm")
	flag.BoolVar(&opt.ignoreConfirm, "y", false, `Alias of "-yes"`)
	flag.BoolVar(&opt.dryrun, "dry-run", false, "Only display target packages")
	flag.BoolVar(&opt.dryrun, "d", false, `Alias of "-dry-run"`)
	flag.BoolVar(&opt.template, "template", false, "Display template of package list")
	flag.BoolVar(&opt.template, "t", false, `Alias of "-template"`)
	flag.Parse()
}

func run(file string, cmdline []string, ignoreConfirm bool, dryrun bool) error {
	f, err := os.Open(file)
	if err != nil {
		return err
	}
	defer f.Close()

	var urls []string
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		if err := sc.Err(); err != nil {
			return err
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
		return fmt.Errorf("package not found in \"%s\"", file)
	}

	fmt.Printf("Packages:\n\t%s\n", strings.Join(urls, "\n\t"))
	fmt.Printf("Run:\n\t%q\n", append(cmdline, "package"))
	if dryrun {
		return nil
	}

	if !ignoreConfirm {
		fmt.Printf("[yes|no]?> ")
		sc := bufio.NewScanner(os.Stdin)
		for {
			if !sc.Scan() {
				return errors.New("scan failed")
			}
			if err := sc.Err(); err != nil {
				return err
			}
			switch sc.Text() {
			case "y", "yes":
				break
			case "n", "no":
				return errors.New("stopped")
			}
		}
	}

	for _, url := range urls {
		cmd := exec.Command(cmdline[0], append(cmdline, url)[1:]...)
		cmd.Stderr = os.Stderr
		cmd.Stdout = os.Stdout
		cmd.Stdin = os.Stdin
		if err := cmd.Run(); err != nil {
			return err
		}
	}

	return nil
}

func main() {
	if flag.NArg() != 0 {
		flag.Usage()
		os.Exit(1)
	}

	if opt.template {
		fmt.Println(template)
		return
	}

	cmdline := []string{"go", "get", "-v"}
	if opt.upgrade {
		cmdline = append(cmdline, "-u")
	}

	if err := run(opt.file, cmdline, opt.ignoreConfirm, opt.dryrun); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
