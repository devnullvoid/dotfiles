// ============================================================================
// KEY MAPPINGS (vimium-flavored)
// ============================================================================

// Tab navigation
api.map('gt', 'T'); // tab switcher
api.map('gT', 'E'); // previous tab (vimium-style)
api.map('J', 'E');  // J/K -> prev/next tab
api.map('K', 'R');

// Omnibar shortcuts (o already searches tabs/bookmarks/history by default)
api.mapkey('O', '#8Open omnibar in current tab', function() {
    Front.openOmnibar({ type: 'URLs', extra: 'getAllSites' });
});
api.mapkey('b', '#8Open bookmarks in omnibar', function() {
    Front.openOmnibar({ type: 'Bookmarks' });
});
api.mapkey('B', '#8Open browser history in omnibar', function() {
    Front.openOmnibar({ type: 'History' });
});
api.mapkey('t', '#8Open URL in new tab', function() {
    Front.openOmnibar({ type: 'URLs', extra: 'newTab' });
});

// History + page movement
api.mapkey('H', '#1Back (vimium-style)', function() { history.go(-1); });
api.mapkey('L', '#1Forward (vimium-style)', function() { history.go(1); });
api.mapkey('d', '#2Half page down', function() {
    window.scrollBy({ top: window.innerHeight / 2, behavior: 'smooth' });
});
api.mapkey('u', '#2Half page up', function() {
    window.scrollBy({ top: -window.innerHeight / 2, behavior: 'smooth' });
});
api.mapkey('gg', '#2Scroll to top', function() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
});
api.mapkey('G', '#2Scroll to bottom', function() {
    window.scrollTo({
        top: document.scrollingElement ? document.scrollingElement.scrollHeight : document.body.scrollHeight,
        behavior: 'smooth'
    });
});
api.mapkey('r', '#3Reload the page', function() { location.reload(); });

// Tab management shortcuts
api.mapkey('xx', '#3Close all tabs to the right', function() {
    api.RUNTIME('closeTabsToRight');
});

// Copy helpers
api.mapkey('yy', '#7Copy current URL', function() {
    api.Clipboard.write(location.href);
});
api.mapkey('ym', '#7Copy URL as markdown link', function() {
    api.Clipboard.write(`[${document.title}](${location.href})`);
});
api.mapkey('yt', '#7Copy page title', function() {
    api.Clipboard.write(document.title);
});
api.mapkey('yf', '#7Copy a link URL via hints', function() {
    api.Hints.create('yf', 'Copy link URL', function(element) {
        var link = element.href || element.src || element.dataset?.url || element.textContent;
        if (!link) {
            Front.showBanner('No URL on target');
            return;
        }
        api.Clipboard.write(link);
        Front.showBanner('Copied: ' + link);
    });
});

// Quick search shortcuts - sequential comma presses for common actions
api.imap(',,', '<Esc>'); // Press comma twice to leave input box
api.imap(';;', "<Ctrl-'>"); // Press semicolon twice to toggle quote

// Vim-like marks
api.mapkey('<Ctrl-i>', '#8Vim-like mark go', function() {
    Normal.jumpVIMark();
});
api.mapkey('m', '#8Vim-like mark set', function() {
    Normal.addVIMark();
});
api.mapkey('[[', '#1Jump to prev result', function() {
    runtime.historyPop(-1);
});
api.mapkey(']]', '#1Jump to next result', function() {
    runtime.historyPop(1);
});

// Catppuccin Mocha micro-theme (compact version of the heavier preset)
(function applyCatppuccinTheme() {
    const mocha = {
        base: '#1e1e2e',
        mantle: '#181825',
        surface0: '#313244',
        surface1: '#45475a',
        surface2: '#585b70',
        text: '#cdd6f4',
        subtext: '#a6adc8',
        blue: '#89b4fa',
        lavender: '#b4befe',
        yellow: '#f9e2af',
        teal: '#94e2d5',
        peach: '#fab387',
        rosewater: '#f5e0dc'
    };

    settings.theme = `
    .sk_theme {
        background: ${mocha.base};
        color: ${mocha.text};
        font-family: "JetBrains Mono NL", "Maple Mono", "Cascadia Code", "Iosevka", Menlo, monospace;
        font-size: 10pt;
        backdrop-filter: blur(12px) saturate(120%);
    }

    .sk_theme input, .sk_theme select, .sk_theme textarea {
        background: ${mocha.surface0};
        color: ${mocha.text};
        border: 1px solid ${mocha.surface2};
        border-radius: 8px;
    }

    .sk_theme .url { color: ${mocha.blue}; }
    .sk_theme .annotation { color: ${mocha.teal}; }
    .sk_theme .omnibar_highlight { color: ${mocha.lavender}; }
    .sk_theme .omnibar_visitcount, .sk_theme .omnibar_timestamp { color: ${mocha.yellow}; }

    #sk_omnibar {
        border: 2px solid ${mocha.lavender};
        border-radius: 14px;
        box-shadow: 0 20px 50px rgba(17,17,27,0.75);
        background: rgba(17,17,27,0.72);
    }
    #sk_omnibarSearchResult ul li:nth-child(odd) { background: ${mocha.surface0}; }
    #sk_omnibarSearchResult ul li.focused {
        background: ${mocha.mantle};
        border-radius: 10px;
        border: 1px solid ${mocha.peach};
    }

    /* Hints: punchy yellow chips */
    #sk_hints .hint {
        background: ${mocha.yellow} !important;
        color: ${mocha.base} !important;
        border: 1px solid ${mocha.rosewater};
        border-radius: 6px;
        box-shadow: 3px 3px 6px rgba(17,17,27,0.55);
        padding: 1px 4px;
        font-size: 8pt;
    }
    #sk_hints .hint-active {
        background: ${mocha.peach} !important;
        color: ${mocha.base} !important;
    }

    #sk_keystroke, #sk_status, #sk_banner {
        background: rgba(17,17,27,0.7);
        color: ${mocha.text};
        border: 1px solid ${mocha.surface2};
        border-radius: 10px;
        box-shadow: 0 15px 30px rgba(17,17,27,0.75);
    }

    #sk_find { font-size: 12pt; }
    `;
})();

// ============================================================================
// SEARCH ENGINE ALIASES
// ============================================================================

// Development & documentation
api.addSearchAlias('gh', 'github', 'https://github.com/search?q=', 's', 'https://api.github.com/search/repositories?sort=stars&order=desc&q=', function(response) {
    var res = JSON.parse(response.text);
    return res.items.map(function(item) {
        return {
            title: item.full_name,
            url: item.html_url,
            description: item.description
        };
    });
});
api.addSearchAlias('so', 'stackoverflow', 'https://stackoverflow.com/search?q=');
api.addSearchAlias('mdn', 'mdn web docs', 'https://developer.mozilla.org/en-US/search?q=');
api.addSearchAlias('npm', 'npm packages', 'https://www.npmjs.com/search?q=');
api.addSearchAlias('crates', 'rust crates', 'https://crates.io/search?q=');
api.addSearchAlias('pypi', 'python packages', 'https://pypi.org/search/?q=');

// General search
api.addSearchAlias('ddg', 'duckduckgo', 'https://duckduckgo.com/?q=');
api.addSearchAlias('yt', 'youtube', 'https://www.youtube.com/results?search_query=');
api.addSearchAlias('wp', 'wikipedia', 'https://en.wikipedia.org/wiki/');
api.addSearchAlias('rd', 'reddit', 'https://www.reddit.com/search?q=');

// AI-powered search engines
api.addSearchAlias('ph', 'phind', 'https://www.phind.com/search?q=');
api.addSearchAlias('px', 'perplexity', 'https://www.perplexity.ai/search/?q=');

// Arch Linux specific (common on CachyOS)
api.addSearchAlias('aw', 'arch wiki', 'https://wiki.archlinux.org/index.php?search=');
api.addSearchAlias('aur', 'aur packages', 'https://aur.archlinux.org/packages?K=');

// ============================================================================
// SITE-SPECIFIC MAPPINGS
// ============================================================================

// GitHub shortcuts
api.mapkey('gi', '#1Open GitHub issues', function() {
    if (window.location.hostname.includes('github.com')) {
        var pathParts = window.location.pathname.split('/').filter(p => p);
        if (pathParts.length >= 2) {
            window.location.href = `https://github.com/${pathParts[0]}/${pathParts[1]}/issues`;
        }
    }
});
api.mapkey('gp', '#1Open GitHub pull requests', function() {
    if (window.location.hostname.includes('github.com')) {
        var pathParts = window.location.pathname.split('/').filter(p => p);
        if (pathParts.length >= 2) {
            window.location.href = `https://github.com/${pathParts[0]}/${pathParts[1]}/pulls`;
        }
    }
});

// ============================================================================
// GENERAL SETTINGS
// ============================================================================

// Scrolling configuration
settings.scrollStepSize = 100; // Larger steps for faster navigation
settings.smoothScroll = true; // Smooth scrolling enabled
settings.scrollFriction = 0; // No friction for precise first step

// Omnibar configuration
settings.omnibarPosition = "bottom"; // Position at bottom of screen
settings.omnibarSuggestion = true; // Show suggestion URLs
settings.omnibarMaxResults = 10; // Results per page
settings.focusFirstCandidate = true; // Auto-focus first result

// Hints configuration
settings.hintAlign = "center"; // Center-align hints on targets
// Uncomment below for right-hand only hint keys if you use mouse with left hand
// api.Hints.setCharacters('yuiophjklnm');

// Tab behavior
settings.tabsThreshold = 100; // Use omnibar when tabs exceed this number
settings.tabsMRUOrder = true; // Show tabs in most recently used order
settings.focusAfterClosed = "right"; // Focus right tab after closing

// Miscellaneous
settings.stealFocusOnLoad = true; // Allow immediate Surfingkeys use on page load
settings.digitForRepeat = true; // Enable repeat counts (like 3j for scroll down 3 times)
settings.defaultSearchEngine = "g"; // Google as default

// ============================================================================
// LLM CONFIGURATION
// ============================================================================

settings.defaultLLMProvider = "custom";
settings.llm = {
    gemini: {
        apiKey: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    },
    custom: {
        serviceUrl: 'https://api.z.ai/api/coding/paas/v4/chat/completions',
        apiKey: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        model: 'GLM-4.5-air',
    }
};

// click `Save` button to make above settings to take effect.</ctrl-i></ctrl-y>




