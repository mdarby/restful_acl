$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'restful_acl'
require 'spec'
require 'spec/autorun'
require 'rubygems'
require 'activesupport'

Spec::Runner.configure do |config|

  def url(path)
    "<a href=\"#{path}\">#{path}</a>"
  end

  def destroy_url(path)
    "<a href=\"#{path}\" onclick=\"if (confirm('Are you sure?')) { var f = document.createElement('form');
     f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;
     var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method');
     m.setAttribute('value', 'delete'); f.appendChild(m);f.submit(); };return false;\">Delete Image</a>"
  end

  def ajax_url(path)
    "<a href=\"#\" onclick=\"if (confirm('Are you sure?')) { $.ajax({beforeSend:function(request){;}, complete:function(request){}, data:'_method=delete', dataType:'script', type:'post', url:'#{path}'}); }; return false;\"></a>"
  end

end
