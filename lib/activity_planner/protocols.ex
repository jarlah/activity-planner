defmodule ActivityPlanner.Protocols do
  alias Crontab.CronExpression

  defimpl Phoenix.HTML.Safe, for: CronExpression do
    def to_iodata(expression) do
      Phoenix.HTML.Safe.to_iodata(Crontab.CronExpression.Composer.compose(expression))
    end
  end
end
