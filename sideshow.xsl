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
    <center><h2 class="title"><xsl:value-of select="@company"/> Collection</h2></center>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="genre">
    <h3 class="genretitle"><xsl:value-of select="@title"/></h3>
    <div class="indent ">
        <xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="format">
    <h3>
        <xsl:value-of select="@kind"/>
        <xsl:if test="@scale"> - <xsl:value-of select="@scale"/> scale</xsl:if>
    </h3>
    <div class="indent">
        <xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="series">
    <div class="series"><xsl:value-of select="@name"/></div>
    <div class="indent">
        <xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="item">
    <xsl:variable name="have" select="@have"/>
    <xsl:variable name="want">
        <xsl:value-of select="@want"/>
        <xsl:if test="not(@want)">0</xsl:if>
    </xsl:variable>
    <xsl:variable name="all" select="$have + $want"/>
    <div>
        <xsl:attribute name="class"><xsl:value-of select="@status"/> count<xsl:value-of select="$all"/></xsl:attribute>
        <xsl:choose>
            <xsl:when test="@status='rumor'">&#9898; </xsl:when>
            <xsl:when test="@status='announced' and $want>0"><font color="goldenrod">&#9734; </font></xsl:when>
            <xsl:when test="(not(@want) or $want=0) and $have>0"><font color="green">&#9745; </font></xsl:when>
            <xsl:when test="$want>0">&#9744; </xsl:when>
            <xsl:otherwise>&#9746; </xsl:otherwise>
        </xsl:choose>
        <xsl:copy-of select="name"/>
    </div>
    <xsl:if test="@exclusiveto"><span class="small notice exclusive"> exclusive to: <xsl:value-of select="@exclusiveto"/></span></xsl:if>
</xsl:template>

<xsl:template match="spacer">
    <hr align="left" width="34%"/>
</xsl:template>

</xsl:stylesheet>