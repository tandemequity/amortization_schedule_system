defmodule AmortizationScheduleCalculator.CompositeInterest do
  @moduledoc """
  This protocol defines the functions used to calculate composite interest.
  """
  alias AmortizationScheduleCalculator, as: ASM

  @doc """
  Calculates the monthly payment given the amount, interest rate and term in months.

  ## Examples

      iex> CompositeInterest.get_monthly_payment(Money.new(:usd, 100000), Decimal.from_float(0.005), 360)
      #Money<:USD, 599.55>

  """
  @spec get_monthly_payment(ASM.loan_amount(), ASM.annual_interest_rate(), ASM.term_in_months()) ::
          ASM.monthly_payment()
  def get_monthly_payment(loan_amount_or_mortage_amount, monthly_interest_rate, term_in_months) do
    eir = effective_interest_rate(term_in_months, monthly_interest_rate)

    loan_amount_or_mortage_amount
    |> Money.mult!(eir)
    |> Money.mult!(monthly_interest_rate)
    |> Money.div!(Decimal.sub(eir, 1))
    |> Money.round()
  end

  @doc """
  Calculates the effective interest rate for the entire period given the number of months and the monthly interest rate.

  ## Examples

      iex> CompositeInterest.effective_interest_rate(360, Decimal.from_float(0.005))
      #Decimal<6.022575212263216184054046820>

  """
  @spec effective_interest_rate(ASM.term_in_months(), ASM.monthly_interest_rate()) ::
          ASM.effective_interest_rate()
  def effective_interest_rate(term_in_months, monthly_interest_rate) do
    Enum.reduce(1..term_in_months, Decimal.new("1"), fn _, acc ->
      Decimal.mult(acc, Decimal.add(monthly_interest_rate, 1))
    end)
  end
end
