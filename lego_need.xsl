<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
    <html>
        <head>
            <title>Collection: <xsl:value-of select="collection/@company"/></title>
            <link rel="stylesheet" href="/style.css" type="text/css"/>
            <script src="/imagepopup.js" language="JavaScript" type="text/javascript"></script>
        </head>
        <body>
            <div style="display: none; border: solid 1px black; width: 346px; height: 397px; position: fixed; right: 10px; top: 10px;" id="preview_div">
                <img src="" id="preview_img" onclick="hideimg();"/>
            </div>
            <xsl:apply-templates/>
        </body>
    </html>
</xsl:template>

<xsl:template match="collection">
    <div class="logo">
        <a><xsl:attribute name="href"><xsl:value-of select="@link"/></xsl:attribute>
            <img><xsl:attribute name="src">/images/logos/<xsl:value-of select="@logo"/></xsl:attribute></img>
        </a>
    </div>
    <center><h2 class="title"><xsl:value-of select="@company"/> Collection (Needs)</h2></center>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="genre">
    <xsl:if test="count(./series/item[@want > 0]) > 0">
        <h3 class="genre"><xsl:value-of select="@title"/></h3>
        <div class="indent">
            <xsl:apply-templates/>
        </div>
    </xsl:if>
</xsl:template>

<xsl:template match="series">
    <xsl:if test="count(./item[@want > 0]) > 0">
        <div class="series"><xsl:value-of select="@name"/>
            <xsl:if test="@title"> : &quot;<xsl:value-of select="@title"/>&quot;</xsl:if>
        </div>
        <xsl:apply-templates/>
    </xsl:if>
</xsl:template>

<xsl:template match="item">
    <xsl:if test="@want > 0">
        <xsl:variable name="want" select="@want"/>
        <div class="indent">
            <xsl:choose>
                <xsl:when test="@status='rumor'">&#9898; </xsl:when>
                <xsl:when test="@status='announced' and $want>0"><font color="goldenrod">&#9734; </font></xsl:when>
                <xsl:when test="$want>0">&#9744; </xsl:when>
                <xsl:otherwise>&#9746; </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@setnum!=''"><span class="small"><xsl:value-of select="@setnum"/></span> - </xsl:if>
            <span onmouseout="hideimg();">
                <xsl:variable name="seriesname" select="../@name"/>
                <xsl:variable name="seriesnum" select="substring-after($seriesname,' ')"/>
                <xsl:attribute name="onclick">showimg(342,393,'/images/legominifigs/<xsl:value-of select="$seriesnum"/><xsl:value-of select="name"/>.jpg');</xsl:attribute>
                <xsl:value-of select="name"/>
            </span>
            <xsl:if test="@packaging"><span class="small"> (<xsl:value-of select="@packaging"/>)</span></xsl:if>
            <xsl:if test="@exclusiveto"><br/><span class="exclusive small notice">exclusive to: <xsl:value-of select="@exclusiveto"/></span></xsl:if>
            <xsl:if test="@releasedate"><br/><span class="release small notice">available: <xsl:value-of select="@releasedate"/></span></xsl:if>
            <xsl:if test="@status='incoming'"><br/><span class="incoming small notice">coming
                <xsl:if test="@seller">from: <xsl:value-of select="@seller"/></xsl:if></span>
            </xsl:if>
        </div>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
