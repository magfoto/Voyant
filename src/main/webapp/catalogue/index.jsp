<%

String query = request.getQueryString();
String[] parts = request.getRequestURI().substring(request.getContextPath().length()+1).split("/");
if (parts.length<2) {
	response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
	response.setHeader("Location", request.getContextPath()+"/"+(query!=null ? "?"+query : ""));
	return;
}
String corpus = parts[1];

%><%@ include file="../resources/jsp/pre_app.jsp" %>
	
<script>
	Ext.Loader.setConfig({
		enabled : true,
		paths : {
			'Voyant' : '../../app',
			'resources': '../../resources',
			'Ext.chart': '../../resources/ext/current/chart'
		}
	});
	Ext.application({
		extend : 'Voyant.VoyantDefaultApp',
		requires: ['Voyant.panel.VoyantHeader','Voyant.panel.Catalogue','Voyant.panel.VoyantFooter'],
		name : 'VoyantToolApp',
		config: {
			baseUrl: '<%= org.voyanttools.voyant.Voyant.getBaseUrlString(request) %>',
			version: '<%= application.getInitParameter("version") %>',
			build: '<%= application.getInitParameter("build") %>',
			corpusId: '<%= corpus %>',
			allowInput: '<%= System.getProperty("org.voyanttools.server.allowinput")==null ? "" : System.getProperty("org.voyanttools.server.allowinput") %>'
		},
		launch: function() {
			this.setApiParam('corpus', this.getCorpusId())
			this.setApiParam('view', 'catalogue');
			if (!this.getApiParam('facet')) {
				if (this.getCorpusId()=='docsouth') {
					this.setApiParam('facet', ['facet.keyword','facet.author'])
				}
			}
			this.callParent(arguments);
		}
	});
	
</script>
<title>Voyant Tools - <%= corpus %></title>
<%@ include file="../resources/jsp/post_app.jsp" %>