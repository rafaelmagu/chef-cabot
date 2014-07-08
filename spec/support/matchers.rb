def install_python_pip(module_name)
  ChefSpec::Matchers::ResourceMatcher.new(:python_pip, :install, module_name)
end
