# Build tasks specific to .NET 4.0 builds.

task :build do
  # Compile some projects for another CLR and pull their artifacts.
  
  projects_built_with_3_5 = {
    :version => 'v3.5',
    :target => "Debug",
    :outDir => "Build/net-3.5/Debug/",
    :projects => [ 'Machine.Specifications.Reporting.Specs', 'Machine.Specifications.ReSharperRunner.5.0' ],
    :artifacts => [ '**/Machine.Specifications.Reporting.Templates.dll', 'Machine.Specifications.ReSharperRunner.5.0.*' ]
    }

  projects_built_with_3_5[:projects].each do |project|
    MSBuild.compile \
      :project => "Source/#{project}/#{project}.csproj",
      :version => projects_built_with_3_5[:version],
      :properties => {
        :Configuration => projects_built_with_3_5[:target]
      }
  end

  projects_built_with_3_5[:artifacts].each do |artifact|
    FileList \
      .new(File.join(projects_built_with_3_5[:outDir], artifact)) \
      .copy_hierarchy \
        :source_dir => projects_built_with_3_5[:outDir],
        :target_dir => configatron.outDir
  end
end