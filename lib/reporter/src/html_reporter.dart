part of codemetrics.reporter;

class HtmlReporter implements AnalysisReporter {

  HtmlReporter(this.analysisRunner);

  StringBuffer getReport() {
    Document template = getHtmlTemplate();
    addReportData(template);
    return new StringBuffer('<!DOCTYPE html>\n' + template.documentElement.outerHtml);
  }

  Document getHtmlTemplate() {
    File templateFile = new File(_TEMPLATE_PATH);
    String contents = templateFile.readAsStringSync();
    return parse(contents, sourceUrl: templateFile.uri.toString());
  }

  void addReportData(Document template) {
    var scriptTag = template.createElement('script')
      ..text = '''
var analysisData = ${JSON.encode(analysisRunner.getResults())}
    ''';
    template.querySelector('head').append(scriptTag);
  }

  final AnalysisRunner analysisRunner;

  static const String _TEMPLATE_PATH = '../lib/reporter/assets/html_reporter_template.html';
}