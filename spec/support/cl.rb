module Support
  module Cl
    def self.included(base)
      base.let(:args) { |e| args_from_description(e) }
      base.subject { cmd }
    end

    def args_from_description(e)
      str = e.example_group.description
      return [] unless str.include?('given')
      strs = str.sub('given', '').strip.split(/\s(?=(?:[^"]|"[^"]*")*$)/)
      strs.map { |str| str.gsub('"', '') }
    end

    def runner(args = nil)
      args ||= respond_to?(:args) ? self.args : args_from_description
      args = [described_class.registry_key.to_s, *args]
      Dpl::Cli.new(ctx, 'dpl').runner(args)
    end

    def cmd(args = nil)
      runner(args).cmd
    end

    def run
      runner.run
    end

    # Beloved squiggly heredocs did not existin Ruby 2.1.0, which we still
    # want to support, so let's give kudos with this method in the meantime.
    def sq(str)
      width = str =~ /( *)\S/ && $1.size
      str.lines.map { |line| line.gsub(/^ {#{width}}/, '') }.join
    end
end
end
