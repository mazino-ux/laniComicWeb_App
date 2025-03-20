<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
    <html>
        <head>
            <title>Collection: <xsl:value-of select="collection/@company"/></title>
            <link rel="stylesheet" href="/style.css" type="text/css"/>
            <script src="/jquery-2.1.1.min.js" language="JavaScript" type="text/javascript"></script>
            <script src="/imagepopup.js" language="JavaScript" type="text/javascript"></script>
        </head>
        <body style="background-color: #eee;">
            <div style="display: none; border: solid 1px black; width: 346px; height: 397px; position: fixed; right: 10px; top: 30px;" id="preview_div">
                <img src="" id="preview_img" onclick="hideimg();"/>
            </div>
            <xsl:apply-templates/>
            <table id="legend" class="info">
                <tr><td class="ltitle">Legend</td></tr>
                <tr><table width="100%" class="info"><tr>
                    <td><font color="green">&#10004;</font></td><td class="ldesc">Have</td>
                    <td>&#10008;</td><td class="ldesc">Don't Want</td>
                    <td>&#9744;</td><td class="ldesc">Want</td>
                    <td><font color="goldenrod">&#9734;</font></td><td class="ldesc">Announced</td>
                    <td>&#9898;</td><td class="ldesc">Rumor</td>
                    <td><font color="red">&#9670;</font></td><td class="ldesc">Damaged</td>
                    <td><font color="darkred">&#8855;</font></td><td class="ldesc">Cancelled</td>
                    <td><span class="money small">$</span></td><td>Price</td>
                </tr></table></tr>
           </table>
        </body>
    </html>
</xsl:template>

<xsl:template match="collection">
    <div class="logo">
        <a><xsl:attribute name="href"><xsl:value-of select="@link"/></xsl:attribute>
            <img><xsl:attribute name="src">/images/logos/<xsl:value-of select="@logo"/></xsl:attribute></img>
        </a>
    </div>
    <div class="maintitle"><xsl:value-of select="@company"/> Collection</div>
    <div id="idx" onclick="toggleIndex();">Index</div>
    <div id="idxlistfixed" class="small" style="display: none;">
        <xsl:attribute name="onmouseup">toggleIndex();</xsl:attribute>
        <xsl:for-each select="genre">
            <xsl:sort select="@title"/>
            <a>
                <xsl:attribute name="href">#Genre_<xsl:value-of select="@title"/></xsl:attribute>
                <xsl:attribute name="onmouseup">toggleIndex(event);</xsl:attribute>
                <xsl:value-of select="@title"/>
            </a><br/>
        </xsl:for-each>
    </div>
    <div id="topspacer"></div>
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="genre">
    <a>
        <xsl:attribute name="name">Genre_<xsl:value-of select="@title"/></xsl:attribute>
    </a>
    <h3 class="genre"><xsl:value-of select="@title"/></h3>
<!--    <xsl:if test="@site">
        <span style="font-size: 80%; text-align: right;"><a>
            <xsl:attribute name="href"><xsl:value-of select="@site"/></xsl:attribute>
            Web
        </a></span>
    </xsl:if>-->
    <div class="indent">
        <xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="series">
    <div class="series"><xsl:value-of select="@name"/>
        <xsl:if test="@title">: &quot;<xsl:value-of select="@title"/>&quot;</xsl:if>
    </div>
    <xsl:apply-templates/>
<!--    <xsl:apply-templates>
        <xsl:sort select="position()" data-type="number" order="descending"/>
    </xsl:apply-templates>-->
</xsl:template>

<xsl:template match="item">
    <xsl:variable name="have" select="@have"/>
    <xsl:variable name="want">
        <xsl:value-of select="@want"/>
        <xsl:if test="not(@want)">0</xsl:if>
    </xsl:variable>
    <xsl:variable name="all" select="$have + $want"/>
    <div>
        <xsl:attribute name="class">indent <xsl:value-of select="@status"/> count<xsl:value-of select="$all"/></xsl:attribute>
        <xsl:choose>
            <xsl:when test="@status='cancelled'"><font color="darkred">&#8855; </font></xsl:when>
            <xsl:when test="@status='rumor'">&#9898; </xsl:when>
            <xsl:when test="@status='announced' and $want>0"><font color="goldenrod">&#9734; </font></xsl:when>
            <xsl:when test="(not(@want) or $want=0) and $have>0"><font color="green">&#10004; </font></xsl:when>
            <xsl:when test="$want>0 and @setnum!=''">
                <span class="hand">
                    <xsl:attribute name="id">check<xsl:value-of select="@setnum"/><xsl:number value="position()" format="1"/></xsl:attribute>
                    <xsl:attribute name="onclick">toggleCheck('check<xsl:value-of select="@setnum"/><xsl:number value="position()" format="1"/>');</xsl:attribute>
                    &#9744; </span>
            </xsl:when>
            <xsl:when test="$want>0">&#9744; </xsl:when>
            <xsl:otherwise>&#10008; </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@setnum!=''">
            <xsl:variable name="prevsetnum" select="preceding-sibling::item[1]/@setnum"/>
            <span>
                <xsl:choose>
                    <xsl:when test="$prevsetnum != '' and $prevsetnum != @setnum - 1">
                        <xsl:attribute name="class">small skipsequence</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise><xsl:attribute name="class">small</xsl:attribute></xsl:otherwise>
                </xsl:choose>
                <a target="_blank" class="nolinkclue">
<!--                <xsl:attribute name="href">http://lego.wikia.com/wiki/<xsl:value-of select="@setnum"/></xsl:attribute>-->
<!--                 <xsl:attribute name="href">http://bricker.info/sets/<xsl:value-of select="@setnum"/>/</xsl:attribute>-->
                <xsl:attribute name="href">https://brickset.com/sets/<xsl:value-of select="@setnum"/>/</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="(not(@status) or @status!='rumor') and $want>0"><b><xsl:value-of select="@setnum"/></b></xsl:when>
                    <xsl:otherwise><xsl:value-of select="@setnum"/></xsl:otherwise>
                </xsl:choose>
                </a>
            </span> - </xsl:if>
        <xsl:choose>
            <xsl:when test="@picsize">
                <span onmouseout="hideimg();" class="hand">
                    <xsl:variable name="seriesname">
                        <xsl:choose>
                            <xsl:when test="../@title"><xsl:value-of select="../@title"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="../@name"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="seriesnum">
                        <xsl:if test="not(../@title)">
                            <xsl:value-of select="substring-after($seriesname,' ')"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:variable name="picfile">
                        <xsl:choose>
                            <xsl:when test="@pic">
                                <xsl:value-of select="@pic"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="translate(translate(name, &quot;.&quot;, &quot;&quot;), &quot;'#:&amp;&quot;, &quot;&quot;)"/>.jpg</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:attribute name="onclick">showimg(<xsl:value-of select="@picsize"/>,'/images/lego/minifigs/<xsl:value-of select="$seriesname"/>/<xsl:value-of select="$seriesnum"/><xsl:value-of select="$picfile"/>');</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$want>0 and (not(@status) or @status!='rumor')"><b><xsl:value-of select="name"/></b></xsl:when>
                        <xsl:otherwise><xsl:value-of select="name"/></xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$want>0 and (not(@status) or @status!='rumor')"><b><xsl:value-of select="name"/></b></xsl:when>
                    <xsl:otherwise><xsl:value-of select="name"/></xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@packaging"><span class="small"> (<xsl:value-of select="@packaging"/>)</span></xsl:if>
        <xsl:if test="@info"><span class="small lead"><i><xsl:value-of select="@info"/></i></span></xsl:if>
        <xsl:variable name="uid" select="generate-id()"/>
        <xsl:if test="minifigures and minifigures/character and minifigures/character/text() != ''">
            <span class="hand minifigicon">
                <xsl:attribute name="onclick">slideToggleVisibility('<xsl:value-of select="$uid"/>');</xsl:attribute>
                &#x1F464;
            </span>
        </xsl:if>
        <xsl:if test="@price > 0">
                <span class="money halfsize marginlead"><xsl:if test="@price &lt;= 9">&#8197;</xsl:if><xsl:value-of select="@price"/><xsl:if test="@price &lt;= 9">&#8197;</xsl:if></span>
        </xsl:if>
        <xsl:if test="not(@status) and $want>0 and @setnum != ''">
            <a target="_blank" class="nolinkclue">
            <xsl:attribute name="href">http://www.ebay.com/sch/i.html?_nkw=lego+<xsl:value-of select="@setnum"/></xsl:attribute>
            <img class="ebay" src="/images/logos/ebay_tiny_bw.png" width="29" height="16" style="padding-left: 5px;"
                onmouseover="this.src='/images/logos/ebay_tiny.png'" onmouseout="this.src='/images/logos/ebay_tiny_bw.png'"/>
            </a>
        </xsl:if>
        <xsl:if test="@exclusiveto"><br/><span class="exclusive small notice">exclusive to: <xsl:value-of select="@exclusiveto"/></span></xsl:if>
        <xsl:if test="@releasedate"><br/><span class="release small notice">available: <xsl:value-of select="@releasedate"/></span></xsl:if>
        <xsl:if test="@status='incoming'"><br/><span class="incoming small notice">coming
            <xsl:if test="@seller">from: <xsl:value-of select="@seller"/></xsl:if></span>
        </xsl:if>
        <xsl:if test="minifigures and minifigures/character and minifigures/character/text() != ''">
            <xsl:apply-templates select="minifigures">
                <xsl:with-param name="uid" select="$uid"/>
            </xsl:apply-templates>
        </xsl:if>
    </div>
</xsl:template>

<xsl:template match="minifigures">
    <xsl:param name="uid"/>
    <div class="indent hidden">
      <xsl:attribute name="id"><xsl:value-of select="$uid"/></xsl:attribute>
      <xsl:attribute name="onclick">slideToggleVisibility('<xsl:value-of select="$uid"/>');</xsl:attribute>
      <div class="minifigs small indent">
        Minifigures:
        <ul>
            <xsl:apply-templates/>
        </ul>
      </div>
    </div>
</xsl:template>

<xsl:template match="character">
    <li>
    <xsl:value-of select="."/>
    <xsl:if test="@count"><span class="small"> x<xsl:value-of select="@count"/></span></xsl:if>
    </li>
</xsl:template>

</xsl:stylesheet>
