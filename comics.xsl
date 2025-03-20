<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes" />

<xsl:param name="today"/> <!--YYYMMDD-->

<xsl:key name="distinct-publisher" match="series" use="@publisher" />
<xsl:key name="distinct-artist" match="issue" use="@coverartist" />
<xsl:key name="distinct-exclusive" match="issue" use="@exclusive" />

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template name="publisherIndex">
    <xsl:param name="publisherName"/>
    <xsl:variable name="currPub" select="/collection/@currentPublisher"/>
    <div class="indextitle">
        <xsl:choose>
            <xsl:when test="contains($currPub, $publisherName)">
                <xsl:attribute name="class">indextitle indextitlesel</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="class">indextitle</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <img>
            <xsl:attribute name="src">/images/logos/<xsl:value-of select="/collection/logos/logo[@id=$publisherName]/img"/></xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="$publisherName"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="/collection/logos/logo[@id=$publisherName]/height">
                    <xsl:attribute name="height"><xsl:value-of select="/collection/logos/logo[@id=$publisherName]/height"/></xsl:attribute>
                </xsl:when>
                <xsl:when test="/collection/logos/height">
                    <xsl:attribute name="height"><xsl:value-of select="/collection/logos/height"/></xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </img>
    </div>
    <div class="indexgroup">
        <xsl:if test="not(contains($currPub, $publisherName))">
            <xsl:attribute name="style">display:none;</xsl:attribute>
        </xsl:if>
        <xsl:for-each select="//series[@publisher=$publisherName]">
            <xsl:sort select="@name"/>
            <a class="bottomJump">
            <xsl:attribute name="destination">Series_<xsl:value-of select="@name"/>
            <xsl:if test="@publisher">_<xsl:value-of select="@publisher"/></xsl:if>
            </xsl:attribute>&#160;&#x2022;&#160;</a>
            <span class="comictitle">
            <xsl:attribute name="class">comictitle <xsl:value-of select="@status"/></xsl:attribute>
            <a>
                <xsl:attribute name="href">#Title_<xsl:value-of select="@name"/>
                <xsl:if test="@publisher">_<xsl:value-of select="@publisher"/></xsl:if>
                </xsl:attribute>
                <xsl:value-of select="@name"/>
            </a>
            <xsl:choose>
                <xsl:when test="@status = 'complete'">&#160;&#x2713;</xsl:when>
                <xsl:when test="@status = 'ended'">&#160;<font color="darkred">&#x29FC;<xsl:value-of select="count(issue[@need]) + count(group/issue[@need])"/>&#x29FD;</font></xsl:when>
            </xsl:choose>
            </span><br/>
        </xsl:for-each>
    </div>
</xsl:template>

<xsl:template match="collection">
    <div id="static-header">
        <h1>Matt's <xsl:value-of select="@theme"/></h1>
        <xsl:if test="@themelogo and @themelogo !=''">
            <img alt=""><xsl:attribute name="src">/images/logos/<xsl:value-of select="@themelogo"/></xsl:attribute></img>
        </xsl:if>
    </div>

    <div id="idxlist" class="indexbox">
        <a href="/" class="nolinkclue"><img id="homeicon" src="/images/home.png"/></a>
        <div id="theindex">
            <xsl:for-each select="series[count(. | key('distinct-publisher', @publisher)[1]) = 1]">
                <xsl:sort select="@publisher"/>
                <xsl:call-template name="publisherIndex">
                    <xsl:with-param name="publisherName"><xsl:value-of select="@publisher"/></xsl:with-param>
                </xsl:call-template>
            </xsl:for-each>
        </div>
        <div id="buttons">
            <center>
            <hr/>
            <input id="hidehave" type="button" value="Hide Haves"/>
            <input id="showall" type="button" value="Show All"/>
            <input id="byrelease" type="button" value="Release"/>
            <xsl:if test="@theme = 'Star Wars Comics'">
                <br/>
                <input id="actionfig" type="button" value="AF" title="Action Figure"/>
                <input id="twentyfifth" type="button" value="25th" title="The Phantom Menace 25th Anniversary"/>
                <input id="fortieth" type="button" value="40th" title="Star Wars 40th Anniversary"/>
                <input id="fiftieth" type="button" value="50th" title="Lucasfilm 50th Anniversary"/>
                <input id="galacticicon" type="button" value="GI" title="Galactic Icon"/>
                <input id="greatestmoments" type="button" value="GM" title="Greatest Moments"/>
                <input id="choosedestiny" type="button" value="CYD" title="Choose Your Destiny"/>
            </xsl:if>
            </center>
        </div>
    </div>

    <div id="comic-content">
        <table width="100%" id="comic-table">
            <xsl:apply-templates/>
        </table>

        <hr style="height:3px;border:0;background-color:grey;"/>
        <div align="right">
            <xsl:value-of select="count(//issue)"/> covers in
            <xsl:value-of select="count(//series)"/> series
            <xsl:variable name="missing" select="count(//issue[@need])"/>
            <xsl:if test="$missing &gt; 1"> | <xsl:value-of select="$missing"/> missing</xsl:if>
        </div>
        <div id="coverartists" class="indexlist">
            <div class="indexlisttitle">Artist Index</div>
            <ol>
            <xsl:for-each select="//issue[count(. | key('distinct-artist', @coverartist)[1]) = 1]">
                <xsl:sort select="@coverartist"/>
                <xsl:if test="@coverartist != ''">
                    <!--<a class="nolinkclue"><xsl:attribute name="href">collection.pl?comics=Star Wars&amp;artist=<xsl:value-of select="@coverartist"/></xsl:attribute>-->
                    <li class="artistname"><nobr><xsl:value-of select="@coverartist"/>
                    <xsl:variable name="pub">
                        <xsl:choose>
                            <xsl:when test="../../@publisher"><xsl:value-of select="../../@publisher"/></xsl:when>
                            <xsl:when test="../@publisher"><xsl:value-of select="@publisher"/></xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="workfor">
                        <xsl:choose>
                            <xsl:when test="$pub = 'Marvel'">M</xsl:when>
                            <xsl:when test="$pub = 'Dark Horse Comics'">DHC</xsl:when>
                            <xsl:otherwise><xsl:value-of select="$pub"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$workfor != ''"><font size="-2"><sup> (<xsl:value-of select="$workfor"/>)</sup></font></xsl:if>
                    </nobr></li>
                    <!--</a>-->
                </xsl:if>
            </xsl:for-each>
            </ol>
            </div>
            <div id="exclusives" class="indexlist">
            <div class="indexlisttitle">Exclusive Index</div>
            <ol>
            <xsl:for-each select="//issue[count(. | key('distinct-exclusive', @exclusive)[1]) = 1]">
                <xsl:sort select="@exclusive"/>
                <xsl:if test="@exclusive != ''">
                    <li class="exclname"><xsl:value-of select="@exclusive"/></li>
                </xsl:if>
            </xsl:for-each>
            </ol>
        </div>
    </div>
</xsl:template>

<xsl:template match="series">
    <tr><td>
    <a class="title-jump">
        <xsl:attribute name="name">Title_<xsl:value-of select="@name"/>
        <xsl:if test="@publisher">_<xsl:value-of select="@publisher"/></xsl:if>
        </xsl:attribute>
    </a>
    <h2 class="comicheader">
        <span class="publisher">
        <xsl:choose>
            <xsl:when test="@publisher"><xsl:value-of select="@publisher"/></xsl:when>
            <xsl:when test="@company"><xsl:value-of select="@company"/></xsl:when>
            <xsl:otherwise>unknown</xsl:otherwise>
        </xsl:choose>
        </span>
        <span class="comictitle">
            <xsl:choose>
                <xsl:when test="@weblink">
                    <a>
                        <xsl:attribute name="href"><xsl:value-of select="@weblink"/></xsl:attribute>
                        <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:value-of select="@name"/></a>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
            </xsl:choose>
        </span>
        <xsl:choose>
            <xsl:when test="@status = 'cancelled'">
                <span class="pubdate">Cancelled</span>
            </xsl:when>
            <xsl:when test="@issue1 and @issue1 != ''">
                <span class="pubdate"><xsl:value-of select="@issue1"/></span>
            </xsl:when>
        </xsl:choose>
    </h2>
<!-- This div produces an issue number index -->
<!--
    <div class="issueindex">
        <xsl:apply-templates mode="index"/> -
    </div>
-->
    <div class="serieswrapper">
        <xsl:attribute name="id">Series_<xsl:value-of select="@name"/>
        <xsl:if test="@publisher">_<xsl:value-of select="@publisher"/></xsl:if>
        </xsl:attribute>
        <xsl:apply-templates/>
    </div>
    </td></tr>
    <!--issue count for series-->
    <tr><td align="right">
        <xsl:variable name="cnt" select="count(issue) + count(group/issue)"/>
        <xsl:variable name="missing" select="count(issue[@need]) + count(group/issue[@need])"/>
        <xsl:value-of select="$cnt"/>
        <xsl:choose>
            <xsl:when test="$cnt = 1">&#160;cover</xsl:when>
            <xsl:otherwise>&#160;covers</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$missing &gt; 1">&#160;|&#160;<xsl:value-of select="$missing"/>&#160;missing</xsl:if>
    </td></tr>
</xsl:template>

<xsl:template match="group">
    <xsl:if test="./*"> <!-- do any children exist -->
    <div class="group dark">
        <div class="issueheader" id="g{generate-id()}">
            <xsl:choose>
                <xsl:when test="@title and @title != ''">
                    <xsl:value-of select="@title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@num and @num != ''">
                            <xsl:call-template name="issue-number">
                                <xsl:with-param name="input" select="@num"/>
                                <xsl:with-param name="grp" select="Y"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="issue/@num and issue/@num != ''">
                            <xsl:call-template name="issue-number">
                                <xsl:with-param name="input" select="issue/@num"/>
                                <xsl:with-param name="grp" select="Y"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="issue[not(@num)] and issue/@cover and issue/@cover != ''">
                            <xsl:value-of select="issue/@cover"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <em>unnumbered</em>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="@subtitle != ''"> - <xsl:value-of select="@subtitle"/></xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <span class="issuecountpopup"><xsl:value-of select="count(./issue)"/> covers</span>
        </div>
        <div class="issue-wrapper">
            <xsl:apply-templates/>
        </div>
    </div>
    </xsl:if>
</xsl:template>

<!-- Do Nothing for these -->
<xsl:template match="logos">
</xsl:template>

<xsl:template match="stores">
</xsl:template>

<!-- These two templates are for putting an issue index above the comics in a series -->
<!--
<xsl:template match="group" mode="index">
    <xsl:if test="number(issue/@num) = issue/@num">
        - <xsl:value-of select="issue/@num"/>
    </xsl:if>
</xsl:template>
<xsl:template match="issue" mode="index">
    <xsl:if test="number(@num) = @num">
        - <xsl:value-of select="@num"/>
    </xsl:if>
</xsl:template>
-->

<xsl:template name="doissue">
    <div id="d{generate-id()}">
        <xsl:attribute name="artist"><xsl:value-of select="@coverartist"/></xsl:attribute>
        <xsl:attribute name="excl"><xsl:value-of select="@exclusive"/></xsl:attribute>
        <xsl:if test="@af = 'Y'">
            <xsl:attribute name="af">Y</xsl:attribute>
        </xsl:if>
        <xsl:if test="@tpm25">
            <xsl:attribute name="TPM25">Y</xsl:attribute>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@cover = '50th LFL Anniv'">
                <xsl:attribute name="LFL50">Y</xsl:attribute>
            </xsl:when>
            <xsl:when test="@cover = 'CYD'">
                <xsl:attribute name="CYD">Y</xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="@wrapcover = 'Y'">
            <xsl:attribute name="style">width: 260px !important;</xsl:attribute>
        </xsl:if>
<!--                <xsl:if test="@coverartist != ''">
                    <div><strong><xsl:value-of select="@coverartist"/></strong></div>
                </xsl:if>
                <xsl:if test="@exclusive != ''">
                    <div class="small"><xsl:value-of select="@exclusive"/></div>
                </xsl:if>
-->
        <xsl:variable name="uid" select="generate-id()"/>
        <xsl:variable name="pdate">
            <xsl:choose>
                <xsl:when test="@pubdate = 'cancelled' or ../@pubdate = 'cancelled'">-1</xsl:when>
                <xsl:when test="@pubdate = 'unknown' or ../@pubdate = 'unknown' or not(@pubdate or ../@pubdate)">99999999</xsl:when>
                <xsl:when test="string-length(@pubdate) = 4"><xsl:value-of select="@pubdate"/>1231</xsl:when>
                <xsl:when test="@pubdate">
                    <xsl:call-template name="date-to-number">
                        <xsl:with-param name="input" select="@pubdate"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="string-length(../@pubdate) = 4"><xsl:value-of select="../@pubdate"/>1231</xsl:when>
                <xsl:when test="../@pubdate">
                    <xsl:call-template name="date-to-number">
                        <xsl:with-param name="input" select="../@pubdate"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="../@issue1">
                    <xsl:call-template name="date-to-number">
                        <xsl:with-param name="input" select="../@issue1"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:attribute name="datestamp"><xsl:value-of select="$pdate"/></xsl:attribute>
        <xsl:attribute name="class">img comic
            <xsl:if test="@pic != '' and (@artpic = 'Y' or @altpic != '')">
                hand
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@pubdate = 'cancelled' or ../@pubdate = 'cancelled'">cancel</xsl:when>
                <xsl:when test="not (@need)">ownit</xsl:when>
                <xsl:when test="@need = 'unconfirmed'">unconfirmed</xsl:when>
                <xsl:when test="@need = '?'">unknown</xsl:when>
                <xsl:when test="@need and @bidding = 'ebay'">ebay</xsl:when>
                <xsl:when test="@need and @incoming">incomingcomic</xsl:when>
                <xsl:when test="@need &lt;= 0 and @have=0">noneed</xsl:when>
                <xsl:when test="@need and @country and not (@country = '' or @country = 'USA') and not (@preview) and $today &gt;= $pdate">foreign</xsl:when>
                <xsl:when test="@need and not (@preview) and $today &gt;= $pdate">need</xsl:when>
                <xsl:when test="@need or $today &lt; $pdate">pre</xsl:when>
                <xsl:otherwise>ownit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:variable name="picfolder">
            <xsl:choose>
                <xsl:when test="@picfolder"><xsl:value-of select="@picfolder"/></xsl:when>
                <xsl:when test="ancestor::series/@picfolder"><xsl:value-of select="ancestor::series/@picfolder"/></xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@pic != '' and not(@nopic)">
                <xsl:if test="@anniversary40 and @anniversary40 != ''"><anni40badge><xsl:value-of select="@anniversary40"/></anni40badge></xsl:if>
                <xsl:if test="@galacticicon and @galacticicon != ''"><giconbadge><xsl:value-of select="@galacticicon"/></giconbadge></xsl:if>
                <xsl:if test="@greatestmoments and @greatestmoments != ''"><grmtbadge><xsl:value-of select="@greatestmoments"/></grmtbadge></xsl:if>
                <img class="lazy" height="200" src="" style="display: block;">
                    <xsl:choose>
                        <xsl:when test="@wrapcover = 'Y'">
                            <xsl:attribute name="width">260</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="width">130</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="data-src">/images/comics/<xsl:value-of select="$picfolder"/><xsl:value-of select="@pic"/></xsl:attribute>
                    <xsl:if test="@anniversary40 and @anniversary40 != ''"><xsl:attribute name="anniv40"><xsl:value-of select="@anniversary40"/></xsl:attribute></xsl:if>
                    <xsl:if test="@galacticicon and @galacticicon != ''"><xsl:attribute name="gicon"><xsl:value-of select="@galacticicon"/></xsl:attribute></xsl:if>
                    <xsl:if test="@greatestmoments and @greatestmoments != ''"><xsl:attribute name="grmt"><xsl:value-of select="@greatestmoments"/></xsl:attribute></xsl:if>
                    <xsl:choose>
                        <xsl:when test="@artpic = 'Y' and @altpic != ''">
                            <xsl:attribute name="id"><xsl:value-of select="$uid"/></xsl:attribute>
                            <xsl:attribute name="onclick">cycleImg('<xsl:value-of select="$uid"/>',false,'/images/comics/<xsl:value-of select="$picfolder"/>','<xsl:value-of select="substring-before(@pic,'.jpg')"/> - art.jpg','<xsl:value-of select="@altpic"/>','<xsl:value-of select="@pic"/>');</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@altpic != ''">
                            <xsl:attribute name="id"><xsl:value-of select="$uid"/></xsl:attribute>
                            <xsl:attribute name="onclick">cycleImg('<xsl:value-of select="$uid"/>',false,'/images/comics/<xsl:value-of select="$picfolder"/>','<xsl:value-of select="@altpic"/>','<xsl:value-of select="@pic"/>');</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@artpic = 'Y'">
                            <xsl:attribute name="id"><xsl:value-of select="$uid"/></xsl:attribute>
                            <xsl:attribute name="onclick">cycleImg('<xsl:value-of select="$uid"/>',false,'/images/comics/<xsl:value-of select="$picfolder"/>','<xsl:value-of select="substring-before(@pic,'.jpg')"/> - art.jpg','<xsl:value-of select="@pic"/>');</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                </img>
            </xsl:when>
            <xsl:when test="@altpic != '' and not(@nopic)">
                <xsl:if test="@anniversary40 and @anniversary40 != ''"><anni40badge><xsl:value-of select="@anniversary40"/></anni40badge></xsl:if>
                <xsl:if test="@galacticicon and @galacticicon != ''"><giconbadge><xsl:value-of select="@galacticicon"/></giconbadge></xsl:if>
                <xsl:if test="@greatestmoments and @greatestmoments != ''"><grmtbadge><xsl:value-of select="@greatestmoments"/></grmtbadge></xsl:if>
                <img class="lazy" height="200" src="" style="display: block;">
                    <xsl:choose>
                        <xsl:when test="@wrapcover = 'Y'">
                            <xsl:attribute name="width">260</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="width">130</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="data-src">/images/comics/<xsl:value-of select="$picfolder"/><xsl:value-of select="@altpic"/></xsl:attribute>
                    <xsl:if test="@anniversary40 and @anniversary40 != ''"><xsl:attribute name="anniv40"><xsl:value-of select="@anniversary40"/></xsl:attribute></xsl:if>
                    <xsl:if test="@galacticicon and @galacticicon != ''"><xsl:attribute name="gicon"><xsl:value-of select="@galacticicon"/></xsl:attribute></xsl:if>
                    <xsl:if test="@greatestmoments and @greatestmoments != ''"><xsl:attribute name="grmt"><xsl:value-of select="@greatestmoments"/></xsl:attribute></xsl:if>
                </img>
            </xsl:when>
            <xsl:otherwise>
                <div style="height:200px; width:130px; background:gray;">
                    <br/><div class="small nopicname"><xsl:value-of select="ancestor::series[1]/@name"/></div>
                    <br/><span class="nopic">No Picture</span>
                    <div class="small">
                    <xsl:if test="@coverartist != ''">
                        <br/><strong><xsl:value-of select="@coverartist"/></strong>
                        <xsl:if test="@coverartist2 != ''">
                            <br/><strong><xsl:value-of select="@coverartist2"/></strong>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="@cover != ''">
                        <br/><em><xsl:value-of select="@cover"/></em>
                    </xsl:if>
                    <xsl:if test="@exclusive != ''">
                        <br/><em><xsl:value-of select="@exclusive"/></em>
                    </xsl:if>
                    <xsl:if test="@desc != ''">
                        <br/><xsl:value-of select="@desc"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="@pubdate != ''">
                            <br/><br/><xsl:value-of select="@pubdate"/>
                        </xsl:when>
                        <xsl:when test="../@pubdate != ''">
                            <br/><br/><xsl:value-of select="../@pubdate"/>
                        </xsl:when>
                    </xsl:choose>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        <div>
            <xsl:attribute name="class">comicinfo h18
                <xsl:if test="@pic != '' and (@artpic = 'Y' or @altpic != '')">
                    hand
                </xsl:if>
                <xsl:if test="contains(@cover,'metal')">
                    metal
                </xsl:if>
            </xsl:attribute>
            <span class="shiftdown">
                <xsl:if test="@exclusive != '' and (not(@pubdate) or @pubdate != 'cancelled') and (not(../@pubdate) or ../@pubdate != 'cancelled')">
                    <span style="float:left;color:yellow;"><xsl:attribute name="title"><xsl:value-of select="@exclusive"/></xsl:attribute>&#x2726;</span>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="contains(@cover,'sketch')">
                        <span style="float:right;color:yellow;"><xsl:attribute name="title"><xsl:value-of select="@cover"/></xsl:attribute>&#x270E;</span>
                    </xsl:when>
                    <xsl:when test="contains(@cover,'foil')">
                        <span style="float:right;color:yellow;font-size:125%;"><xsl:attribute name="title"><xsl:value-of select="@cover"/></xsl:attribute>&#x24BB;</span>
                    </xsl:when>
                    <xsl:when test="contains(@cover,'metal')">
                        <span style="float:right;color:yellow;font-size:125%;"><xsl:attribute name="title"><xsl:value-of select="@cover"/></xsl:attribute>&#x24C2;</span>
                    </xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="@preview"><span class="dim">P - </span></xsl:when>
                    <xsl:when test="$pdate and $today &lt; $pdate"><span class="dim">P - </span></xsl:when>
                </xsl:choose>

                <!-- put an issue number here if we have set a group title -->
                <xsl:if test="name(..) = 'group' and ../@title != ''">
                    <xsl:choose>
                        <xsl:when test="@num and @num != ''">
                            <xsl:call-template name="issue-number">
                                <xsl:with-param name="input" select="@num"/>
                            </xsl:call-template>&#160;
                        </xsl:when>
                        <xsl:when test="../@num and ../@num != ''">
                            <xsl:call-template name="issue-number">
                                <xsl:with-param name="input" select="../@num"/>
                            </xsl:call-template>&#160;
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>

                <xsl:choose>
                    <xsl:when test="@coverartist != ''">
                        <xsl:choose>
                            <xsl:when test="@psuedoname">
                                <xsl:value-of select="@coverartist"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="substring-after-last">
                                    <xsl:with-param name="input" select="@coverartist"/>
                                    <xsl:with-param name="marker" select="' '"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@cover != ''">
                        <xsl:value-of select="@cover"/>
                    </xsl:when>
                    <xsl:when test="@desc != ''">
                        <em><xsl:value-of select="@desc"/></em>
                    </xsl:when>
                    <xsl:when test="@exclusive != ''">
                        <em><xsl:value-of select="@exclusive"/></em>
                    </xsl:when>
                    <xsl:when test="count(preceding-sibling::issue)=0">
                        <em>regular</em>
                    </xsl:when>
                    <xsl:otherwise>
                        <em>variant</em>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="number(@printing) = @printing">
                    (<xsl:call-template name="printing-count">
                        <xsl:with-param name="input" select="@printing"/>
                    </xsl:call-template>)
                </xsl:if>
            </span>
<!--            <xsl:if test="@coverartist != ''"> - <xsl:value-of select="substring-after(@coverartist,' ')"/></xsl:if> -->
<!--            <xsl:if test="@coverartist != ''"> - <xsl:value-of select="tokenize('aaa-bbb-ccc-ddd','-')[last()]"/></xsl:if>  XSLT2.0 -->
        </div>
        <xsl:if test="(@pic != '' or @altpic != '') and (@part or @coverartist or @exclusive or @limited or @pubdate or @desc or ../@pubdate or ../@part)">
            <div class="comicinfo fullinfo hidden">
                <xsl:if test="@wrapcover = 'Y'">
                    <xsl:attribute name="style">width: 260px;</xsl:attribute>
                </xsl:if>
                <div>
                    <xsl:choose>
                        <xsl:when test="@preview"><span class="dim">Pre - </span></xsl:when>
                        <xsl:when test="$today &lt; $pdate"><span class="dim">Pre - </span></xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="@num and @num != ''">
                            <xsl:call-template name="issue-number">
                                <xsl:with-param name="input" select="@num"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="../@num and ../@num != ''">
                            <xsl:call-template name="issue-number">
                                <xsl:with-param name="input" select="../@num"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="@cover != ''">
                        <xsl:if test="(@num and @num != '') or (../@num and ../@num != '')"> - </xsl:if>
                        <xsl:value-of select="@cover"/>
                    </xsl:if>
                </div>
                <xsl:choose>
                    <xsl:when test="../@part != ''">
                        <div>Part <xsl:value-of select="../@part"/>
                        <xsl:if test="../@run != ''"> of <xsl:value-of select="../@run"/></xsl:if>
                        </div>
                    </xsl:when>
                    <xsl:when test="@part != ''">
                        <div>Part <xsl:value-of select="@part"/>
                        <xsl:if test="@run != ''"> of <xsl:value-of select="@run"/></xsl:if>
                        </div>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="number(@printing) = @printing">
                    <div>
                    <xsl:call-template name="printing-count">
                        <xsl:with-param name="input" select="@printing"/>
                    </xsl:call-template>
                    printing
                    </div>
                </xsl:if>
                <xsl:if test="@coverartist != ''">
                    <div><strong><xsl:value-of select="@coverartist"/></strong></div>
                    <xsl:if test="@coverartist2 != ''">
                        <div><strong><xsl:value-of select="@coverartist2"/></strong></div>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="@exclusive != ''">
                    <div class="small"><xsl:value-of select="@exclusive"/></div>
                </xsl:if>
                <xsl:if test="@country != ''">
                    <div><xsl:value-of select="@country"/></div>
                </xsl:if>
                <xsl:if test="@limited != ''">
                    <div><xsl:value-of select="@limited"/><xsl:if test="number(@limited) = @limited"> printed</xsl:if></div>
                </xsl:if>
                <xsl:if test="@printratio != ''">
                    <div><xsl:value-of select="@printratio"/> (<xsl:value-of select="format-number(100 div substring-after(@printratio,':'), '#0.#')"/>%)</div>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="@pubdate != ''">
                        <xsl:choose>
                            <xsl:when test="@pubdate = 'cancelled' or ../@pubdate = 'cancelled' or @status = 'cancelled'">
                                <div class="cancelled">Cancelled</div>
                            </xsl:when>
                            <xsl:otherwise>
                                <div><xsl:value-of select="@pubdate"/></div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="../@pubdate != ''">
                        <div><xsl:value-of select="../@pubdate"/></div>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="@desc != ''">
                    <div class="dim"><xsl:value-of select="@desc"/></div>
                </xsl:if>
            </div>
        </xsl:if>
    </div>
</xsl:template>

<xsl:template match="issue">
    <xsl:choose>
        <xsl:when test="name(..) = 'group'">
            <xsl:call-template name="doissue"/>
        </xsl:when>
        <xsl:otherwise>
            <!-- parent node is not a group -->
            <div class="group dark">
                <div class="issueheader" id="g{generate-id()}">
                    <xsl:choose>
                        <xsl:when test="@num and @num != ''">
                            <xsl:call-template name="issue-number">
                                <xsl:with-param name="input" select="@num"/>
                                <xsl:with-param name="grp" select="Y"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="(not(@num) or @num = '') and @cover and @cover != ''">
                            <xsl:value-of select="@cover"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <em>unnumbered</em>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <xsl:if test="@title and @title != ''">
                    <div style="position: relative;">
                        <xsl:if test="not(@need) or @need &lt;= 0"><xsl:attribute name="class">inithide</xsl:attribute></xsl:if>
                        <div class="title90"><xsl:value-of select="@title"/></div>
                    </div>
                </xsl:if>
                <div class="issue-wrapper">
                    <xsl:if test="@title and @title != ''">
                        <xsl:attribute name="style">margin-left: 1em;</xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="doissue"/>
                </div>
            </div>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="issue-number">
    <xsl:param name="input"/>
    <xsl:param name="grp"/>
    <xsl:if test="$input = number($input) or substring-before($input, ' ') = number(substring-before($input, ' '))">#</xsl:if>
    <xsl:choose>
        <xsl:when test="$grp != 'Y' and contains($input, ' ') and contains('0123456789', substring($input,1,1))">
            <xsl:value-of select="substring-before($input, ' ')"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$input"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="printing-count">
    <xsl:param name="input"/>
    <xsl:value-of select="$input"/><sup>
    <xsl:choose>
        <xsl:when test="$input mod 10 = 1 and $input mod 100 != 11">st</xsl:when>
        <xsl:when test="$input mod 10 = 2 and $input mod 100 != 12">nd</xsl:when>
        <xsl:when test="$input mod 10 = 3 and $input mod 100 != 13">rd</xsl:when>
        <xsl:otherwise>th</xsl:otherwise>
    </xsl:choose></sup>
</xsl:template>

<xsl:template name="substring-after-last">
    <xsl:param name="input"/>
    <xsl:param name="marker"/>
    <xsl:choose>
        <xsl:when test="contains($input, ' Jr.')">
            <xsl:call-template name="substring-after-last">
                <xsl:with-param name="input" select="substring-before($input, ' Jr.')"/>
                <xsl:with-param name="marker" select="$marker"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($input, $marker)">
            <xsl:call-template name="substring-after-last">
                <xsl:with-param name="input" select="substring-after($input, $marker)"/>
                <xsl:with-param name="marker" select="$marker"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$input"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="date-to-number">
    <xsl:param name="input"/>
    <!-- input is of the form "month dd, yyyy" -->
    <xsl:value-of select="substring($input, string-length($input) - 3)"/>
    <xsl:value-of select="format-number(string-length(substring-before('JanFebMarAprMayJunJulAugSepOctNovDec', substring($input,1,3))) div 3 + 1, '00')"/>
    <xsl:choose>
        <xsl:when test="contains($input, ',')">
            <xsl:value-of select="format-number(substring-after(substring-before($input, ','), ' '), '00')"/>
        </xsl:when>
        <xsl:otherwise>00</xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
