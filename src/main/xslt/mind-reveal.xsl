<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">

        <html>
            <head>
                <meta charset="utf-8" />
                <title><xsl:value-of select="map/node/@TEXT"/></title>

                <meta name="description" content="A framework for easily creating beautiful presentations using HTML" />
                <meta name="author" content="Hakim El Hattab" />

                <meta name="apple-mobile-web-app-capable" content="yes" />
                <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />

                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

                <link rel="stylesheet" href="css/reveal.min.css" />
                <link rel="stylesheet" href="css/theme/default.css" id="theme" />
                <link rel="stylesheet" href="css/custom.css" id="custom" />

                <!-- For syntax highlighting -->
                <link rel="stylesheet" href="lib/css/zenburn.css" />

                <!-- If the query includes 'print-pdf', include the PDF print sheet -->
                <script>
                    if( window.location.search.match( /print-pdf/gi ) ) {
                    var link = document.createElement( 'link' );
                    link.rel = 'stylesheet';
                    link.type = 'text/css';
                    link.href = 'css/print/pdf.css';
                    document.getElementsByTagName( 'head' )[0].appendChild( link );
                    }
                </script>
            </head>
            <body>
                <div class="reveal">
                    <div class="slides">
                        <section>
                            <h1><xsl:value-of select="map/node/@TEXT"/></h1>
                            <xsl:if test="map/node/attribute[@NAME='author' and @VALUE!='']">
                                <p><xsl:value-of select="map/node/attribute[@NAME='author']/@VALUE"/></p>
                            </xsl:if>
                            <xsl:if test="map/node/attribute[@NAME='date' and @VALUE!='']">
                                <p>
                                    Datum:
                                    <strong>
                                        <xsl:value-of select="map/node/attribute[@NAME='date']/@VALUE"/>
                                    </strong>
                                </p>
                            </xsl:if>
                        </section>
                        <xsl:for-each select="map/node/node[icon/@BUILTIN='list'] | map/node/node[icon/@BUILTIN='folder']">
                            <xsl:apply-templates select="." />
                        </xsl:for-each>
                    </div>
                </div>

                <script src="lib/js/head.min.js"></script>
                <script src="js/reveal.min.js"></script>

                <script>
                    Reveal.initialize({
                    controls: true,
                    progress: true,
                    history: true,
                    center: true,

                    width: 1200,
                    height: 800,
                    margin: 0.0,
                    minScale: 0.2,
                    maxScale: 2.0,

                    theme: "sky", // available themes are in /css/theme
                    transition: Reveal.getQueryHash().transition || 'default', // default/cube/page/concave/zoom/linear/fade/none

                    // Parallax scrolling
                    //parallaxBackgroundImage: 'https://s3.amazonaws.com/hakim-static/reveal-js/reveal-parallax-1.jpg',
                    //parallaxBackgroundSize: '2100px 900px',

                    // Optional libraries used to extend on reveal.js
                    dependencies: [
                    { src: 'lib/js/classList.js', condition: function() { return !document.body.classList; } },
                    { src: 'plugin/markdown/marked.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
                    { src: 'plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
                    { src: 'plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
                    { src: 'plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },
                    { src: 'plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } }
                    ]
                    });

                </script>
            </body>
        </html>

    </xsl:template>

    <!-- Section -->
    <xsl:template match="node[icon/@BUILTIN='folder']">
        <section>
            <section>
                <xsl:if test="@BACKGROUND_COLOR">
                    <xsl:attribute name="data-background"><xsl:value-of select="@BACKGROUND_COLOR"/></xsl:attribute>
                </xsl:if>
                <h2>
                    <xsl:value-of select="@TEXT"/>
                </h2>
            </section>
            <xsl:apply-templates select="node" />
        </section>
    </xsl:template>

    <!-- Slide -->
    <xsl:template match="node[icon/@BUILTIN='list']">
        <section>
            <xsl:if test="@BACKGROUND_COLOR">
                <xsl:attribute name="data-background"><xsl:value-of select="@BACKGROUND_COLOR"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="icon/@BUILTIN='full-2'">
                <xsl:attribute name="class">two-columns</xsl:attribute>
            </xsl:if>
            <xsl:if test="@TEXT!=''">
                <h2>
                    <xsl:value-of select="@TEXT"/>
                </h2>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="icon/@BUILTIN='full-2'">
                    <xsl:for-each select="node">
                        <div class="column">
                            <xsl:if test="@TEXT!=''">
                                <h3>
                                    <xsl:value-of select="@TEXT"/>
                                </h3>
                            </xsl:if>
                            <xsl:call-template name="slide-content"/>
                        </div>
                    </xsl:for-each>
                    <div style="clear: both"></div>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="slide-content"/>
                </xsl:otherwise>
            </xsl:choose>
        </section>
    </xsl:template>

    <xsl:template name="slide-content">
        <xsl:choose>
            <!-- Code slide -->
            <xsl:when test="node[icon/@BUILTIN='pencil']">
                <xsl:for-each select="node">
                    <xsl:choose>
                        <xsl:when test="icon/@BUILTIN='pencil'">
                            <pre><code><xsl:if test="attribute[@NAME='lang']">
                                <xsl:attribute name="class"><xsl:value-of select="attribute[@NAME='lang']/@VALUE"/></xsl:attribute>
                            </xsl:if>
                                <xsl:value-of select="@TEXT"/></code></pre>
                        </xsl:when>
                        <xsl:otherwise>
                            <p><xsl:call-template name="node-output"/></p>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>

            <!-- Code slide -->
            <xsl:when test="node[icon/@BUILTIN='licq']">
                <xsl:for-each select="node">
                    <xsl:choose>
                        <xsl:when test="icon/@BUILTIN='licq' and @LINK">
                            <img>
                                <xsl:attribute name="src"><xsl:value-of select="@LINK" /></xsl:attribute>
                                <xsl:attribute name="alt"><xsl:value-of select="@TEXT" /></xsl:attribute>
                            </img>
                        </xsl:when>
                        <xsl:otherwise>
                            <p><xsl:call-template name="node-output"/></p>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>

            <!-- Rich content slide (e.g. with image) -->
            <xsl:when test="node/richcontent">
                <xsl:for-each select="node">
                    <xsl:choose>
                        <xsl:when test="richcontent">
                            <xsl:copy-of select="richcontent/html/body/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <p><xsl:call-template name="node-output"/></p>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>

            <xsl:otherwise>
                <ul>
                    <xsl:for-each select="node">
                        <li>
                            <xsl:call-template name="node-output"/>

                            <xsl:if test="node">
                                <ul>
                                    <xsl:for-each select="node">
                                        <li>
                                            <xsl:call-template name="node-output"/>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </xsl:if>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="node-output">
        <xsl:choose>
            <xsl:when test="@LINK">
                <a>
                    <xsl:attribute name="href"><xsl:value-of select="@LINK"/></xsl:attribute>
                    <xsl:call-template name="node-output-format"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="node-output-format"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="node-output-format">
        <xsl:choose>
            <xsl:when test="@COLOR | font[@ITALIC='true'] | font[@BOLD='true']">
                <span>
                    <xsl:attribute name="style">
                        <xsl:if test="@COLOR">color: <xsl:value-of select="@COLOR"/>; </xsl:if>
                        <xsl:if test="font[@ITALIC='true']">font-style: italic; </xsl:if>
                        <xsl:if test="font[@BOLD='true']">font-weight: bold; </xsl:if>
                    </xsl:attribute>
                    <xsl:value-of select="@TEXT"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@TEXT"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>