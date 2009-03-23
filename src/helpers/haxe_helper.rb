require 'yaml'
require 'fileutils'
module HaxeHelper
  def haxe name
    compile name
  
    params = {
      :type => "application/x-shockwave-flash",
      :pluginspage => "http://www.macromedia.com/go/getflashplayer",
      :src => "swfs/#{name}.swf"
    }.merge(YAML.load File.read("src/haxe/#{name}/meta.yaml"))
    
    %{
<object id="haxe_#{name}" width="#{params[:width]}" height=#{params[:height]}">
  #{params.map{|k,v| param k, v }.join('')}
  <embed #{hash_to_attrs params} />
</object>
}
  end
  
  def compile name
    system "cd src/haxe/#{name} && haml document.haml > document.xml"
    system "cd src/haxe/#{name} && sass stylesheet.sass > stylesheet.css"
    system "cd src/haxe/#{name} && haxe compile.hxml"
    FileUtils.mv "src/haxe/#{name}/#{name}.swf", "site/swfs"
    FileUtils.rm "src/haxe/#{name}/document.xml"
    FileUtils.rm "src/haxe/#{name}/stylesheet.css"
    Kernel.puts
    Kernel.puts
  end
  
  def hash_to_attrs hash
    hash.map{|k,v| %{#{k}="#{v}"}}.join(' ')
  end
  
  def param name, value
    %{<param name="#{name}" value="#{value}" />}
  end
end
