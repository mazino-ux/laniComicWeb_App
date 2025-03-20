<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
    <html>
        <head>
            <title>Collection: <xsl:value-of select="collection/@company"/></title>
            <link rel="stylesheet" href="/style.css" type="text/css"/>
            <script src="/imagepopup.js" language="JavaScript" type="text/javascript"></script>
        </head>
        <body>
            <xsl:apply-templates/>
        </body>
    </html>
</xsl:template>

<xsl:template match="collection">
    <xsl:if test="@logo != ''">
        <div class="logo">
            <xsl:if test="@logo2 != ''">
                <xsl:choose>
                    <xsl:when test="@link2 != ''">
                        <a><xsl:attribute name="href"><xsl:value-of select="@link2"/></xsl:attribute>
                        <img><xsl:attribute name="src">/images/logos/<xsl:value-of select="@logo2"/></xsl:attribute></img>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <img><xsl:attribute name="src">/images/logos/<xsl:value-of select="@logo2"/></xsl:attribute></img>
                    </xsl:otherwise>
                </xsl:choose>
                <br/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@link != ''">
                    <a><xsl:attribute name="href"><xsl:value-of select="@link"/></xsl:attribute>
                    <img><xsl:attribute name="src">/images/logos/<xsl:value-of select="@logo"/></xsl:attribute></img>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <img><xsl:attribute name="src">/images/logos/<xsl:value-of select="@logo"/></xsl:attribute></img>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:if>
    <center><h2 class="title"><xsl:value-of select="@theme"/> Collection</h2></center>
    <table width="100%">
        <xsl:apply-templates/>
    </table>
</xsl:template>

<xsl:template match="category">
    <tr><td>
    <h2 class="category">
        <xsl:value-of select="@name"/>
        <xsl:if test="@scale"> - <xsl:value-of select="@scale"/></xsl:if>
        <xsl:if test="@year"> <span class="small lead">[<xsl:value-of select="@year"/>]</span></xsl:if>
    </h2>
    <xsl:apply-templates/>
    </td></tr>
</xsl:template>

<xsl:template match="group">
    <div class="series">
        <xsl:if test="@example and @example != ''">
            <img class="float"><xsl:attribute name="src">/images/hasbro/<xsl:value-of select="@example"/></xsl:attribute></img>
        </xsl:if>
        <xsl:value-of select="@type"/>
    </div>
    <div class="stripe indent">
        <xsl:if test="@cardid and @cardid!=''">
            <xsl:attribute name="style">background-image: url("/images/hasbro/<xsl:value-of select="@cardid"/>_stripe.jpg");</xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="wave">
    <xsl:choose>
        <xsl:when test="(@num and @num!='') or (@name and @name!='')">
            <div><div class="wave">
                <span class="small">Wave
                    <xsl:if test="@num and @num!=''"><span class="wavenum"><xsl:value-of select="@num"/></span></xsl:if>
                    <xsl:if test="(@num and @num!='') and (@name and @name!='')"> - </xsl:if>
                    <xsl:if test="@name and @name!=''"><span class="wavename"><xsl:value-of select="@name"/></span></xsl:if>
                </span>
                <xsl:apply-templates/>
            </div></div>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="multipack">
    <xsl:choose>
        <xsl:when test="@name and @name!=''">
            <div><div class="wave">
                <span class="small"><xsl:value-of select="@name"/></span>
                <xsl:apply-templates/>
            </div></div>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="item">
    <xsl:variable name="have" select="@have"/>
    <xsl:variable name="want">
        <xsl:value-of select="@want"/>
        <xsl:if test="not(@want)">0</xsl:if>
    </xsl:variable>
    <xsl:variable name="all" select="$have + $want"/>

    <div class="item">
        <xsl:attribute name="class">indent <xsl:value-of select="@status"/> count<xsl:value-of select="$all"/></xsl:attribute>
        <xsl:choose>
            <xsl:when test="@status='cancelled'"><font color="darkred">&#8855; </font></xsl:when>
            <xsl:when test="@status='rumor'">&#9898; </xsl:when>
            <xsl:when test="@status='announced' and $want>0"><font color="goldenrod">&#9734; </font></xsl:when>
            <xsl:when test="$have>0"><font color="green">&#10004; </font></xsl:when>
            <xsl:when test="$want>0">&#9744; </xsl:when>
            <xsl:otherwise>&#10008; </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="@status='cancelled'"><font color="darkred">&#8195; </font></xsl:when>
            <xsl:when test="@status='rumor'">&#8195; </xsl:when>
            <xsl:when test="@status='announced' and $want>1"><font color="goldenrod">&#9734; </font></xsl:when>
            <xsl:when test="@status='announced' and $want &lt; 2"><font color="goldenrod">&#10008; </font></xsl:when>
            <xsl:when test="$have>1"><font color="green">&#10004; </font></xsl:when>
            <xsl:when test="($have=0 and $want>1) or ($have=1 and $want>0)">&#9744; </xsl:when>
            <xsl:otherwise>&#10008; </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="@id!=''">
            <xsl:value-of select="@id"/> - </xsl:if>
        <xsl:copy-of select="."/>
        <xsl:if test="@note"><span class="halfsize notice info"><xsl:value-of select="@note"/></span></xsl:if>
        <xsl:if test="@exclusiveto"><br/><span class="exclusive small notice">exclusive to: <xsl:value-of select="@exclusiveto"/></span></xsl:if>
    </div>
</xsl:template>

</xsl:stylesheet>
