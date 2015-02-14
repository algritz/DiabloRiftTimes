# Run Helper contains helper methods that are accessible through
# the Runs views
module RunsHelper
  def ready?(count)
    count >= 10 ? 'Yes' : 'No'
  end
end
