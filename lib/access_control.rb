module AccessControl
  class AccessControlList
    attr_accessor :restrictions

    def initialize
      self.restrictions = {}
      super
    end

    # Pass in a condition to test and a block to execute if it's true, then name it for later execution on-demand.
  # Call like add_restriction('only_allow_admins', ) {do_if_restricted()}
    def add_restriction(name, condition, default_block)
      self.restrictions[name] = {:condition => condition, :default_block => default_block}
    end

    # Run the specified registered access check, execute the block if no match.
    def restrict(name, block)
      block.nil? ? self.restrictions[name][:default_block].call : block.call unless self.restrictions[name][:condition]
      return !(self.restrictions[name][:condition])
    end
  end
end