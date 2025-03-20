<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
    <html>
        <head>
            <title>Collection: <xsl:value-of select="collection/@company"/></title>
            <link rel="stylesheet" href="/style.css" type="text/css"/>
        </head>
        <body>
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
    <xsl:if test="count(./format/series/item[@want > 0]) + count(./format/item[@want > 0]) > 0">
        <h3 class="genre"><xsl:value-of select="@title"/></h3>
        <div class="indent">
            <xsl:apply-templates/>
        </div>
    </xsl:if>
</xsl:template>

<xsl:template match="format">
    <xsl:if test="count(./series/item[@want > 0]) + count(./item[@want > 0]) > 0">
        <h3>
            <xsl:value-of select="@kind"/>
            <xsl:if test="@scale"> - <xsl:value-of select="@scale"/> scale</xsl:if>
        </h3>
        <div class="indent">
            <xsl:apply-templates/>
        </div>
    </xsl:if>
</xsl:template>

<xsl:template match="series">
    <xsl:if test="count(./item[@want > 0]) > 0">
        <div class="series"><xsl:value-of select="@name"/></div>
        <div class="indent">
            <xsl:apply-templates/>
        </div>
    </xsl:if>
</xsl:template>

<xsl:template match="item">
    <xsl:if test="@want > 0">
        <xsl:variable name="want" select="@want"/>
        <div>
            <xsl:attribute name="class"><xsl:value-of select="@status"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="@status='rumor'">&#9898; </xsl:when>
                <xsl:when test="@status='announced' and $want>0"><font color="goldenrod">&#9734; </font></xsl:when>
                <xsl:when test="$want>0">&#9744; </xsl:when>
                <xsl:otherwise>&#9746; </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="name"/>
        </div>
        <xsl:if test="@exclusiveto"><span class="small notice exclusive"> exclusive to: <xsl:value-of select="@exclusiveto"/></span></xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template match="spacer">
    <hr align="left" width="34%"/>
</xsl:template>

</xsl:stylesheet>
