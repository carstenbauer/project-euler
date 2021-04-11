### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ bdbd372b-23c9-421a-9130-d3ab03a33453
begin
	using Pkg
	Pkg.activate(@__DIR__)
	using BenchmarkTools
	using Test
	using DelimitedFiles
	using Primes
	using Combinatorics
	Base.active_project()
end

# ╔═╡ 1ab55840-84a3-11eb-0b24-8bcce01520f4
include((@__DIR__)*"/shared.jl");

# ╔═╡ 1ab55840-84a3-11eb-0d06-bb5d9f576ac1
html"""
<h2>Problem 26: Reciprocal cycles</h2>
<p>A unit fraction contains 1 in the numerator. The decimal representation of the unit fractions with denominators 2 to 10 are given:</p>
<blockquote>
<table><tr><td><sup>1</sup>/<sub>2</sub></td><td>= </td><td>0.5</td>
</tr><tr><td><sup>1</sup>/<sub>3</sub></td><td>= </td><td>0.(3)</td>
</tr><tr><td><sup>1</sup>/<sub>4</sub></td><td>= </td><td>0.25</td>
</tr><tr><td><sup>1</sup>/<sub>5</sub></td><td>= </td><td>0.2</td>
</tr><tr><td><sup>1</sup>/<sub>6</sub></td><td>= </td><td>0.1(6)</td>
</tr><tr><td><sup>1</sup>/<sub>7</sub></td><td>= </td><td>0.(142857)</td>
</tr><tr><td><sup>1</sup>/<sub>8</sub></td><td>= </td><td>0.125</td>
</tr><tr><td><sup>1</sup>/<sub>9</sub></td><td>= </td><td>0.(1)</td>
</tr><tr><td><sup>1</sup>/<sub>10</sub></td><td>= </td><td>0.1</td>
</tr></table></blockquote>
<p>Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It can be seen that <sup>1</sup>/<sub>7</sub> has a 6-digit recurring cycle.</p>
<p>Find the value of <i>d</i> &lt; 1000 for which <sup>1</sup>/<sub><i>d</i></sub> contains the longest recurring cycle in its decimal fraction part.</p>
"""

# ╔═╡ 117ec84e-65cd-40c4-b870-97afa9883dd1
function reccycle_length(d)
	rems = Int[]
	push!(rems, 1%d)
	while true
		r = (10*last(rems))%d
		println(r)
		if r in rems || r == 0
			return length(rems)
		else
			push!(rems, r)
		end
	end
end

# ╔═╡ ed13dad1-e081-4689-92a5-6776c0eed8b4
function euler26()
	maxsqlen = 0
	dmax = 0
	
	for d in reverse(1:1000)
		maxsqlen >= d && break
		sqlen = reccycle_length(d)
		if sqlen > maxsqlen
			maxsqlen = sqlen
			dmax = d
		end
	end
	return dmax, maxsqlen
end

# ╔═╡ 1fc45c36-7de2-48fe-a207-22c4f7d616ee
euler26_answer, _ = euler26()

# ╔═╡ 1ab55840-84a3-11eb-2a1c-e1a0e40a8d60
begin
    submit_answer(euler26_answer; prob_num=26)
end

# ╔═╡ 1ab55840-84a3-11eb-1581-0fa993520c3e
html"""
<h2>Problem 27: Quadratic primes</h2>
<p>Euler discovered the remarkable quadratic formula:</p>
<p class="center">$n^2 + n + 41$</p>
<p>It turns out that the formula will produce 40 primes for the consecutive integer values $0 \le n \le 39$. However, when $n = 40, 40^2 + 40 + 41 = 40(40 + 1) + 41$ is divisible by 41, and certainly when $n = 41, 41^2 + 41 + 41$ is clearly divisible by 41.</p>
<p>The incredible formula $n^2 - 79n + 1601$ was discovered, which produces 80 primes for the consecutive values $0 \le n \le 79$. The product of the coefficients, −79 and 1601, is −126479.</p>
<p>Considering quadratics of the form:</p>
<blockquote>
$n^2 + an + b$, where $|a| &lt; 1000$ and $|b| \le 1000$<br /><br /><div>where $|n|$ is the modulus/absolute value of $n$<br />e.g. $|11| = 11$ and $|-4| = 4$</div>
</blockquote>
<p>Find the product of the coefficients, $a$ and $b$, for the quadratic expression that produces the maximum number of primes for consecutive values of $n$, starting with $n = 0$.</p>
"""

# ╔═╡ 3698fba9-9738-4dc3-8090-823604286874
formula(n,a,b) = n^2 + a*n + b

# ╔═╡ 6a4cf689-5a60-4a3a-87e1-39d30dd0a5ef
# using Primes
function count_consec_primes(a,b)
    n = 0
    while isprime(formula(n,a,b))
        n+=1
    end
    return n
end

# ╔═╡ 7bfa44f7-d1af-435e-8560-3dea3f6a52f9
begin
	@test all(isprime.(formula.(0:39,1,41)))
	@test all(isprime.(formula.(0:79,-79,1601)))
	
	@test count_consec_primes(1,41) == 40
	@test count_consec_primes(-79,1601) == 80
end

# ╔═╡ d6ef8eb1-c5b7-4974-bc7f-52198434d336
function euler27(param_range)
    amax, bmax, nmax = 0, 0, 0
    for a in param_range
        for b in param_range
            n = count_consec_primes(a,b)
            if n > nmax
                amax, bmax, nmax = a, b, n
            end
        end
    end
    return amax, bmax, nmax
end

# ╔═╡ 2212d416-1c97-47e4-9c2b-ca72a9ab6fa3
begin
	@test euler27(1:50) == (1,41,40)
	@test euler27(-100:1700) == (-79,1601,80)
end

# ╔═╡ 83aa34d1-0665-48d9-8328-ef82de35dce9
begin
	a,b,n = euler27(-999:999)
	euler27_answer = a*b
end

# ╔═╡ 1ab55840-84a3-11eb-0e89-d1cc04d4f5d5
begin
    submit_answer(euler27_answer; prob_num=27)
end

# ╔═╡ 1ab55840-84a3-11eb-1b99-07b97224a53c
html"""
<h2>Problem 28: Number spiral diagonals</h2>
<p>Starting with the number 1 and moving to the right in a clockwise direction a 5 by 5 spiral is formed as follows:</p>
<p style="font-family:'courier new';text-align:center;font-size:10pt;"><span style="color:#ff0000;"><b>21</b></span> 22 23 24 <span style="color:#ff0000;"><b>25</b></span><br />
20  <span style="color:#ff0000;"><b>7</b></span>  8  <span style="color:#ff0000;"><b>9</b></span> 10<br />
19  6  <span style="color:#ff0000;"><b>1</b></span>  2 11<br />
18  <span style="color:#ff0000;"><b>5</b></span>  4  <span style="color:#ff0000;"><b>3</b></span> 12<br /><span style="color:#ff0000;"><b>17</b></span> 16 15 14 <span style="color:#ff0000;"><b>13</b></span></p>
<p>It can be verified that the sum of the numbers on the diagonals is 101.</p>
<p>What is the sum of the numbers on the diagonals in a 1001 by 1001 spiral formed in the same way?</p>
"""

# ╔═╡ 7de59000-4b77-498a-923a-e08ade7e8376
zeros(1001,1001)

# ╔═╡ 1ab55840-84a3-11eb-1209-4990258968d5
begin
    submit_answer(nothing; prob_num=28)
end

# ╔═╡ 1ab55840-84a3-11eb-2c82-35fad13828b3
html"""
<h2>Problem 29: Distinct powers</h2>
<p>Consider all integer combinations of <i>a</i><sup><i>b</i></sup> for 2 ≤ <i>a</i> ≤ 5 and 2 ≤ <i>b</i> ≤ 5:</p>
<blockquote>2<sup>2</sup>=4, 2<sup>3</sup>=8, 2<sup>4</sup>=16, 2<sup>5</sup>=32<br />
3<sup>2</sup>=9, 3<sup>3</sup>=27, 3<sup>4</sup>=81, 3<sup>5</sup>=243<br />
4<sup>2</sup>=16, 4<sup>3</sup>=64, 4<sup>4</sup>=256, 4<sup>5</sup>=1024<br />
5<sup>2</sup>=25, 5<sup>3</sup>=125, 5<sup>4</sup>=625, 5<sup>5</sup>=3125<br /></blockquote>
<p>If they are then placed in numerical order, with any repeats removed, we get the following sequence of 15 distinct terms:</p>
<p class="center">4, 8, 9, 16, 25, 27, 32, 64, 81, 125, 243, 256, 625, 1024, 3125</p>
<p>How many distinct terms are in the sequence generated by <i>a</i><sup><i>b</i></sup> for 2 ≤ <i>a</i> ≤ 100 and 2 ≤ <i>b</i> ≤ 100?</p>
"""

# ╔═╡ 41decafb-c8a8-4246-a615-76b8599c0d66
function euler29(N)
    s = Set{BigInt}()
    for a in big(2):big(N), b in 2:N
        push!(s, a^b)
    end
    return length(s)
end

# ╔═╡ c6bddd98-f358-498a-b7db-10bdd1b58966
@test euler29(5) == 15

# ╔═╡ fd93a123-86eb-49f0-b7fe-1bb0bc04b047
euler29_answer = euler29(100)

# ╔═╡ 1ab55840-84a3-11eb-2d5b-ed9672cecbd9
begin
    submit_answer(euler29_answer; prob_num=29)
end

# ╔═╡ 1ab55840-84a3-11eb-3723-d199ccc7ae10
html"""
<h2>Problem 30: Digit fifth powers</h2>
<p>Surprisingly there are only three numbers that can be written as the sum of fourth powers of their digits:</p>
<blockquote>1634 = 1<sup>4</sup> + 6<sup>4</sup> + 3<sup>4</sup> + 4<sup>4</sup><br />
8208 = 8<sup>4</sup> + 2<sup>4</sup> + 0<sup>4</sup> + 8<sup>4</sup><br />
9474 = 9<sup>4</sup> + 4<sup>4</sup> + 7<sup>4</sup> + 4<sup>4</sup></blockquote>
<p class="smaller">As 1 = 1<sup>4</sup> is not a sum it is not included.</p>
<p>The sum of these numbers is 1634 + 8208 + 9474 = 19316.</p>
<p>Find the sum of all the numbers that can be written as the sum of fifth powers of their digits.</p>
"""

# ╔═╡ 8256b8d0-b545-4d25-8693-616022e2f408
check(n; pow=5) = sum(d^pow for d in digits(n)) == n

# ╔═╡ 4a3fc8a5-d4bc-4bd3-baa1-7093fa06a642
begin
	@test check(1634; pow=4)
	@test check(8208; pow=4)
	@test check(9474; pow=4)
end

# ╔═╡ 9421a49e-7035-4ab7-822e-8db9de3999b6
begin
	upper_limit_ndigits() = findfirst(n -> ndigits(n*9^5) < n, 1:10)
	upper_limit_ndigits()
end

# ╔═╡ a0d319ca-653b-4b27-b819-0997d07eca42
begin
	function euler30()
	    s = 0
	    for n in 2:10^upper_limit_ndigits()
	        if check(n)
	            s += n
	        end
	    end
	    return s
	end
	
	euler30_answer = euler30()
end

# ╔═╡ 1ab55840-84a3-11eb-24e8-e3f4e3be42ba
begin
    submit_answer(euler30_answer; prob_num=30)
end

# ╔═╡ 1ab55840-84a3-11eb-145d-53e135d5c358
html"""
<h2>Problem 31: Coin sums</h2>
<p>In the United Kingdom the currency is made up of pound (£) and pence (p). There are eight coins in general circulation:</p>
<blockquote>1p, 2p, 5p, 10p, 20p, 50p, £1 (100p), and £2 (200p).</blockquote>
<p>It is possible to make £2 in the following way:</p>
<blockquote>1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p</blockquote>
<p>How many different ways can £2 be made using any number of coins?</p>
"""

# ╔═╡ a8199a55-008d-4456-b8d1-11f90eb89e83
const coins = [1,2,5,10,20,50,100,200]

# ╔═╡ 21c04794-a1ee-45a6-849a-2708412fb7a8
begin
	function div_and_conq(total; smallest_coin=1)
		# smallest_coin to avoid overcounting symmetry partners
	    nways = total == 0 ? 1 : 0
	    for c in coins
	        if total >= c && c >= smallest_coin
	            nways += div_and_conq(total-c; smallest_coin=c)
	        end
	    end
	    return nways
	end
	
	euler31_answer = div_and_conq(200)
end

# ╔═╡ 1ab55840-84a3-11eb-0522-9fb06f5651f9
begin
    submit_answer(euler31_answer; prob_num=31)
end

# ╔═╡ 1ab55840-84a3-11eb-2a71-e38fdab264f8
html"""
<h2>Problem 32: Pandigital products</h2>
<p>We shall say that an <var>n</var>-digit number is pandigital if it makes use of all the digits 1 to <var>n</var> exactly once; for example, the 5-digit number, 15234, is 1 through 5 pandigital.</p>

<p>The product 7254 is unusual, as the identity, 39 × 186 = 7254, containing multiplicand, multiplier, and product is 1 through 9 pandigital.</p>

<p>Find the sum of all products whose multiplicand/multiplier/product identity can be written as a 1 through 9 pandigital.</p>

<div class="note">HINT: Some products can be obtained in more than one way so be sure to only include it once in your sum.</div>
"""

# ╔═╡ dd0b5ae6-854a-42c7-93ca-eaa34ed30c0b
begin
	function ispandigital!(tmp, n::Integer)
	    d = sort!(digits!(tmp, n))
	    return d == 1:length(d)
	end
	
	digits2integer(ds; natural=false) = sum(((i, x),) -> x * 10^(i - 1), pairs(natural ? reverse(ds) : ds))
end

# ╔═╡ 39ce63f0-fa97-4547-a38c-8e71d8b79d86
function euler32()
    memory = Set{Int}()
    tmp = zeros(Int, 9)
    for a in 1:9999
        for b in 1:9999
            c = a*b
            ndigits(c) + ndigits(a) + ndigits(b) == 9 || continue
            c in memory && continue
            num = digits2integer(vcat(digits(c), digits(a), digits(b)))
            if ispandigital!(tmp, num)
                push!(memory, c)
            end
        end
    end
    return sum(memory)
end

# ╔═╡ d8704c7a-99a2-4226-9cb4-bdfc5704466d
euler32_answer = euler32()

# ╔═╡ 1ab55840-84a3-11eb-2654-fd530b59c837
begin
    submit_answer(euler32_answer; prob_num=32)
end

# ╔═╡ 5050cbf9-9d6e-47e5-a540-90cd646bdf1a
md"**Appendix: reducing allocations**"

# ╔═╡ d254a97c-17c0-4b9d-a460-a74e901fceef
begin
	function combine_integers(x, y)
	    if y != 0
	        a = floor(Int, log10(y))
	    else
	        a = -1
	    end
	
	    return x*10^(1+a)+y
	end
	
	function euler32_less_allocs()
	    memory = Set{Int}()
	    tmp = zeros(Int, 9)
	    for a in 1:9999
	        for b in 1:9999
	            c = a*b
	            ndigits(c) + ndigits(a) + ndigits(b) == 9 || continue
	            c in memory && continue
	            num = combine_integers(combine_integers(a,b), c)
	            if ispandigital!(tmp, num)
	                push!(memory, c)
	            end
	        end
	    end
	    return sum(memory)
	end
end

# ╔═╡ 5029e897-0b36-43e3-bd13-e24aafc23356
# @benchmark euler32()

# ╔═╡ 4766ca26-75f1-4733-a8c2-2aa4068113fb
# @benchmark euler32_less_allocs()

# ╔═╡ 1ab55840-84a3-11eb-201b-1736c0f13319
html"""
<h2>Problem 33: Digit cancelling fractions</h2>
<p>The fraction <sup>49</sup>/<sub>98</sub> is a curious fraction, as an inexperienced mathematician in attempting to simplify it may incorrectly believe that <sup>49</sup>/<sub>98</sub> = <sup>4</sup>/<sub>8</sub>, which is correct, is obtained by cancelling the 9s.</p>
<p>We shall consider fractions like, <sup>30</sup>/<sub>50</sub> = <sup>3</sup>/<sub>5</sub>, to be trivial examples.</p>
<p>There are exactly four non-trivial examples of this type of fraction, less than one in value, and containing two digits in the numerator and denominator.</p>
<p>If the product of these four fractions is given in its lowest common terms, find the value of the denominator.</p>
"""

# ╔═╡ 1d915f12-c146-4169-aab5-a1b71f442679
begin
	struct CuriousChecker
	    digits_nom::Vector{Int}
	    digits_denom::Vector{Int}
	    CuriousChecker() = new(zeros(2), zeros(2))
	end
	
	function (cc::CuriousChecker)(nom, denom)
	    dn = cc.digits_nom
	    dd = cc.digits_denom
	    digits!(dn, nom)
	    digits!(dd, denom)
	    r = nom//denom
	   
	    # only select non-trivial curious numbers
	    r == 1 && return false
	    (0 in dn && 0 in dd) && return false
	    
	    if dn[1] == dd[1] && dn[2]//dd[2] == r
	        return true
	    elseif dn[1] == dd[2] && dn[2]//dd[1] == r
	        return true
	    elseif dn[2] == dd[1] && dn[1]//dd[2] == r
	        return true
	    elseif dn[2] == dd[2] && dn[1]//dd[1] == r
	        return true
	    else
	        return false
	    end
	end
end

# ╔═╡ 32d6e229-7ba8-4ef2-8c8a-c98ffb6133ee
begin
	iscurious = CuriousChecker()
	@test iscurious(49, 98)
	@test !iscurious(12, 14)
	@test !iscurious(30, 50) # trivial => not curious
	@test !iscurious(11, 11) # trivial => not curious
end

# ╔═╡ c40ec4be-b167-4041-a5db-eaedb69fd656
function euler33()
    r = 1//1
    iscurious = CuriousChecker()
    for denom in 10:99
        for nom in 10:denom
            if iscurious(nom, denom)
                r *= nom//denom
            end
        end
    end
    return r.den
end

# ╔═╡ 50113e18-0410-4ee5-8af9-c24bcc68b34a
euler33_answer = euler33()

# ╔═╡ 1ab55840-84a3-11eb-015a-ffb9b6554e7a
begin
    submit_answer(euler33_answer; prob_num=33)
end

# ╔═╡ 1ab55840-84a3-11eb-2535-8b7135ec1f00
html"""
<h2>Problem 34: Digit factorials</h2>
<p>145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.</p>
<p>Find the sum of all numbers which are equal to the sum of the factorial of their digits.</p>
<p class="smaller">Note: As 1! = 1 and 2! = 2 are not sums they are not included.</p>
"""

# ╔═╡ e64505ac-5c36-416c-9bf4-dcd6aa8183bc
function iscurious_factorial(n)
	(n == 1 || n == 2) && return false
	return sum(factorial(i) for i in digits(n)) == n
end

# ╔═╡ 69813cd7-0a4c-468a-b0c7-0bcf7c9fcd85
begin
	@test iscurious_factorial(145)
	@test !iscurious_factorial(111)
end

# ╔═╡ bf505af1-4d7f-4cac-ad6a-e61a8069f8b3
euler34() = sum(n for n in 1:100_000 if iscurious_factorial(n))

# ╔═╡ 995a4cfa-8d6b-419f-ad19-c787840a43e4
euler34_answer = euler34()

# ╔═╡ 1ab55840-84a3-11eb-1f8d-a78f018810e0
begin
    submit_answer(euler34_answer; prob_num=34)
end

# ╔═╡ 1ab55840-84a3-11eb-252c-416f92d2d8c9
html"""
<h2>Problem 35: Circular primes</h2>
<p>The number, 197, is called a circular prime because all rotations of the digits: 197, 971, and 719, are themselves prime.</p>
<p>There are thirteen such primes below 100: 2, 3, 5, 7, 11, 13, 17, 31, 37, 71, 73, 79, and 97.</p>
<p>How many circular primes are there below one million?</p>
"""

# ╔═╡ 83c4cfb5-b0e7-45c3-9cb0-e728fc39ecfd
# using Primes
function iscircularprime(n)
	isprime(n) || return false
	digs = digits(n)
	ncirc = length(digs)
	for i in 1:length(digs)-1
		nshifted = digits2integer(circshift(digs, i))
		isprime(nshifted) || return false
	end
	return true
end

# ╔═╡ a2204590-0283-4d8a-bab0-36045a64c358
begin
	test_vec = [2, 3, 5, 7, 11, 13, 17, 31, 37, 71, 73, 79, 97]
	@test all(iscircularprime.(test_vec))
	@test !any(iscircularprime.([4,19,29,53]))
end

# ╔═╡ 0ada01a1-1dca-4cb8-9a90-dca7920a404d
# @benchmark iscircularprime(197)

# ╔═╡ 1562aee3-9c3f-49d7-bfbf-7f1c94ed1155
@test count(iscircularprime, 1:100) == length(test_vec)

# ╔═╡ 0ce1a24a-6873-4ac6-a691-2a556d2da464
euler35_answer = count(iscircularprime, 1:1_000_000)

# ╔═╡ 1ab55840-84a3-11eb-19fe-8d95e96357f4
begin
    submit_answer(euler35_answer; prob_num=35)
end

# ╔═╡ 1ab55840-84a3-11eb-1dc7-01153bf71005
html"""
<h2>Problem 36: Double-base palindromes</h2>
<p>The decimal number, 585 = 1001001001<sub>2</sub> (binary), is palindromic in both bases.</p>
<p>Find the sum of all numbers, less than one million, which are palindromic in base 10 and base 2.</p>
<p class="smaller">(Please note that the palindromic number, in either base, may not include leading zeros.)</p>
"""

# ╔═╡ 6dfec37f-6764-47e9-864a-50daf873f966
ispalindrome(n; base=10) = digits(n; base) == reverse(digits(n; base))

# ╔═╡ ee208648-92fb-4f05-a248-646a786011ab
begin
	@test ispalindrome(585; base=10)
	@test ispalindrome(585; base=2)
	@test !ispalindrome(15; base=10) # 1111 in base 2
	@test ispalindrome(15; base=2)
end

# ╔═╡ 03c9fd12-310a-40fa-aa5d-c05ad69424b5
euler36_answer = sum(n for n in 1:1_000_000 if ispalindrome(n; base=10) && ispalindrome(n; base=2))

# ╔═╡ 1ab55840-84a3-11eb-1adb-6d608809f6e8
begin
    submit_answer(euler36_answer; prob_num=36)
end

# ╔═╡ 1ab55840-84a3-11eb-0ea2-a3cf38b7ebe1
html"""
<h2>Problem 37: Truncatable primes</h2>
<p>The number 3797 has an interesting property. Being prime itself, it is possible to continuously remove digits from left to right, and remain prime at each stage: 3797, 797, 97, and 7. Similarly we can work from right to left: 3797, 379, 37, and 3.</p>
<p>Find the sum of the only eleven primes that are both truncatable from left to right and right to left.</p>
<p class="smaller">NOTE: 2, 3, 5, and 7 are not considered to be truncatable primes.</p>
"""

# ╔═╡ af62eda5-5450-4e1d-b966-97ce405d609a
function istruncprime(n)
	n < 10 && return false
	isprime(n) || return false
	digs = digits(n)
	# @show digs
	for i in 1:length(digs)
		# println(digits2integer(digs[i:end]))
		# println(digits2integer(digs[1:i]))
		# println()
		isprime(@views digits2integer(digs[i:end])) || return false
		isprime(@views digits2integer(digs[1:i])) || return false
	end
	return true
end

# ╔═╡ 8577d6a3-e3d7-40b5-96a1-200e1a0f6b58
istruncprime(613)

# ╔═╡ ac2f5026-37f2-479a-9329-253175b4a9da
begin
	@test istruncprime(3797)
	@test !istruncprime(1234)
	@test !istruncprime(613)
end

# ╔═╡ 006efa46-3ce3-4484-9632-880ebd0350cb
truncatable_primes = [p for p in primes(1,1_000_000) if istruncprime(p)]

# ╔═╡ 4934e258-9e98-4d75-8880-8f2917a2d9e1
euler37_answer = sum(truncatable_primes)
# or in one line:
# euler37_answer = sum(p for p in primes(1,1_000_000) if istruncprime(p))

# ╔═╡ 1ab55840-84a3-11eb-1bf7-d9716e2ce53c
begin
    submit_answer(euler37_answer; prob_num=37)
end

# ╔═╡ 1ab55840-84a3-11eb-3859-81830cb33d9f
html"""
<h2>Problem 38: Pandigital multiples</h2>
<p>Take the number 192 and multiply it by each of 1, 2, and 3:</p>
<blockquote>192 × 1 = 192<br />
192 × 2 = 384<br />
192 × 3 = 576</blockquote>
<p>By concatenating each product we get the 1 to 9 pandigital, 192384576. We will call 192384576 the concatenated product of 192 and (1,2,3)</p>
<p>The same can be achieved by starting with 9 and multiplying by 1, 2, 3, 4, and 5, giving the pandigital, 918273645, which is the concatenated product of 9 and (1,2,3,4,5).</p>
<p>What is the largest 1 to 9 pandigital 9-digit number that can be formed as the concatenated product of an integer with (1,2, ... , <var>n</var>) where <var>n</var> &gt; 1?</p>
"""

# ╔═╡ 3de6e0bf-7e59-4b34-a24f-e0f82ce40887
ispandigital(n::Vector{<:Integer}) = sort(n) == 1:9

# ╔═╡ 0c2969a6-ea2c-4466-ae2d-dc9f309b5fdd
function ispandigital_and_concat_prod(num)
	digs = Int[]
	i = 0
	while length(digs) < 9
		i+=1
		digs = vcat(digs, reverse!(digits(num*i)))
	end
	n = i
	n == 1 && return false
	return ispandigital(digs), digs, n
end

# ╔═╡ da602110-304d-44d6-a14f-c49d9dd359ea
begin
	@test !ispandigital([1,2,3])
	@test ispandigital([1,4,2,3,6,5,7,9,8])
end

# ╔═╡ 272c900d-d4bb-4f4a-b6e7-c859bf217896
begin
	@test ispandigital_and_concat_prod(192) == (true, [1,9,2,3,8,4,5,7,6], 3)
	@test ispandigital_and_concat_prod(1)[1]
	@test !ispandigital_and_concat_prod(12)[1]
end

# ╔═╡ d095f586-4ab3-4d4f-a73a-58c5b6741ef7
# @benchmark ispandigital_and_concat_prod(192)

# ╔═╡ b3431fe6-7f13-4d8b-a24e-0851afc7be67
function euler38()
	maxpannum = 0
	numval = 0
	nval = 0
	for num in 1:100_000
		iscandidate, digs, n = ispandigital_and_concat_prod(num)
		iscandidate || continue
		pannum = digits2integer(digs; natural=true)
		if pannum > maxpannum
			maxpannum = pannum
			numval = num
			nval = n
		end
	end
	return maxpannum, numval, nval
end

# ╔═╡ a3a3f702-c216-42fc-8f57-4308eca2e569
euler38_answer, _, _ = euler38()

# ╔═╡ 1ab55840-84a3-11eb-339a-c9ec99dc92fe
begin
    submit_answer(euler38_answer; prob_num=38)
end

# ╔═╡ 1ab55840-84a3-11eb-1af0-b70ef22929cf
html"""
<h2>Problem 39: Integer right triangles</h2>
<p>If <i>p</i> is the perimeter of a right angle triangle with integral length sides, {<i>a</i>,<i>b</i>,<i>c</i>}, there are exactly three solutions for <i>p</i> = 120.</p>
<p>{20,48,52}, {24,45,51}, {30,40,50}</p>
<p>For which value of <i>p</i> ≤ 1000, is the number of solutions maximised?</p>
"""

# ╔═╡ e3938b97-0119-4258-945e-96bdf0c35518
# p = a + b + c
# c^2 = a^2 + b^2
# p ≤ 1000
#
# p = a + b + a^2 + b^2

# ╔═╡ 0666b4ff-de6c-4a6f-8de6-c8e341ff1fe7
issolution(p,a,b,c) = p == a+b+c && c^2 == a^2 + b^2

# ╔═╡ bd37ffbd-2202-439a-94ee-a75a8f5633e1
begin
	@test issolution(120, 20,48,52)
	@test issolution(120, 24,45,51)
	@test issolution(120, 30,40,50)
end

# ╔═╡ a60dfe7b-140f-476f-85cb-7d17d134e4ac
function nsolutions(p)
	counter = 0
	for a in 1:p
		for b in a:p
			c = sqrt(a^2 + b^2)
			isinteger(c) || continue
			if issolution(p,a,b,Int(c))
				counter += 1
			end
		end
	end
	return counter
end

# ╔═╡ 2bbe5c6f-cd98-4c4a-9cbc-6b7ed6fced9c
@test nsolutions(120) == 3

# ╔═╡ 12623758-bd96-4a47-badf-c01e8bc26f8b
function maximize_nsolutions()
	max_p = 0
	max_nsolutions = 0
	for p in 3:1000
		ns = nsolutions(p)
		if ns > max_nsolutions
			max_nsolutions = ns
			max_p = p
		end
	end
	return max_p, max_nsolutions
end

# ╔═╡ d2a2b9a1-21ac-48de-abd7-ff16748365ea
euler39_answer, _ = maximize_nsolutions()

# ╔═╡ 1ab55840-84a3-11eb-329a-2b02330da716
begin
    submit_answer(euler39_answer; prob_num=39)
end

# ╔═╡ 1ab55840-84a3-11eb-15e4-c52876cc75aa
html"""
<h2>Problem 40: Champernowne's constant</h2>
<p>An irrational decimal fraction is created by concatenating the positive integers:</p>
<p class="center">0.12345678910<span style="color:#ff0000;">1</span>112131415161718192021...</p>
<p>It can be seen that the 12<sup>th</sup> digit of the fractional part is 1.</p>
<p>If <i>d</i><sub><i>n</i></sub> represents the <i>n</i><sup>th</sup> digit of the fractional part, find the value of the following expression.</p>
<p class="center"><i>d</i><sub>1</sub> × <i>d</i><sub>10</sub> × <i>d</i><sub>100</sub> × <i>d</i><sub>1000</sub> × <i>d</i><sub>10000</sub> × <i>d</i><sub>100000</sub> × <i>d</i><sub>1000000</sub></p>
"""

# ╔═╡ e2f3e770-3591-45ca-abe4-3dc720abda8e
function euler40()
	frac_str = join(1:1_000_000);
	p = 1
	dvals = Int[]
	for i in 0:6
		d = parse(Int, frac_str[10^i])
		push!(dvals, d)
		p *= d
	end
	return p, dvals
end

# ╔═╡ c3f6eab1-56db-4206-b3b8-f9548aafa963
euler40_answer, _ = euler40()

# ╔═╡ 5a5ce3dd-f81e-4ab3-aa7a-887b2eb1d502
begin
    submit_answer(euler40_answer; prob_num=40)
end

# ╔═╡ 76b482e8-ab0a-4ab3-bcdc-f41adecc029a
md"**Appendix: custom iterator**"

# ╔═╡ d1d186d9-6d62-4bcf-9a3a-b63c132e7953
begin
	struct DigitsIterator end
	
	# state = (nth int., curr. digit idx)
	function Base.iterate(di::DigitsIterator, state=(0,1))
		nth = state[1]
		idx = state[2]
		digs = reverse!(digits(nth))
		if idx == length(digs) # no digits left in the nth integer
			nth += 1
			idx = 0
			digs = reverse!(digits(nth))
		end
		return (digs[idx+1], (nth, idx+1))
	end
	
	Base.IteratorSize(::Type{DigitsIterator}) = Base.IsInfinite()
	Base.eltype(::Type{DigitsIterator}) = Int
end

# ╔═╡ e75ed38b-7e92-4afc-94ac-0ec8f66bc8df
first(DigitsIterator(),33)

# ╔═╡ ffcee764-83df-4f15-8cde-c5cd9a1a2b81
begin
	@test first(DigitsIterator(),12)[end] == 1 # 12th digit
	@test first(DigitsIterator(),33) == reverse!(digits(123456789101112131415161718192021))
end

# ╔═╡ 4a875911-234c-422a-9a5d-7c94908fa9f3
function euler40_iterator()
	dvals = Int[]
	di = DigitsIterator()
	next = iterate(di)
	for i in 1:1_000_000
		(digit, state) = next
		if i in (1,10,100,1_000,10_000,100_000,1_000_000)
			push!(dvals, digit)
		end
		next = iterate(di, state)
	end
	return prod(dvals), dvals
end

# ╔═╡ 32d1844c-37c0-4a1c-b57b-d4bc2cf5e673
euler40_iterator_answer, dvals = euler40_iterator()

# ╔═╡ 1ab55840-84a3-11eb-3930-d75cab91a1b5
html"""
<h2>Problem 41: Pandigital prime</h2>
<p>We shall say that an <i>n</i>-digit number is pandigital if it makes use of all the digits 1 to <i>n</i> exactly once. For example, 2143 is a 4-digit pandigital and is also prime.</p>
<p>What is the largest <i>n</i>-digit pandigital prime that exists?</p>
"""

# ╔═╡ 3766903d-fe4a-437e-976e-03c8e204cc3a
function euler41()
	pmax = 0
	for n in 9:-1:1
		for p in permutations(1:n)
			num = digits2integer(p)
			if isprime(num) && num > pmax
				pmax = num
			end
		end
		pmax > 0 && break
	end
	return pmax
end

# ╔═╡ 985ea127-8632-4887-8159-5edfe7af9df9
euler41_answer = euler41()

# ╔═╡ 1ab55840-84a3-11eb-1b75-ff5a3cf5af46
begin
    submit_answer(euler41_answer; prob_num=41)
end

# ╔═╡ 1ab55840-84a3-11eb-3e0a-9fce2c7c8a4e
html"""
<h2>Problem 42: Coded triangle numbers</h2>
<p>The <i>n</i><sup>th</sup> term of the sequence of triangle numbers is given by, <i>t<sub>n</sub></i> = ½<i>n</i>(<i>n</i>+1); so the first ten triangle numbers are:</p>
<p class="center">1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...</p>
<p>By converting each letter in a word to a number corresponding to its alphabetical position and adding these values we form a word value. For example, the word value for SKY is 19 + 11 + 25 = 55 = <i>t</i><sub>10</sub>. If the word value is a triangle number then we shall call the word a triangle word.</p>
<p>Using <a href="project/resources/p042_words.txt">words.txt</a> (right click and 'Save Link/Target As...'), a 16K text file containing nearly two-thousand common English words, how many are triangle words?</p>
"""

# ╔═╡ 4722f2e8-4525-4d3a-bcd4-a295921fa87d
words = vec(readdlm("project/resources/p042_words.txt", ',', String))

# ╔═╡ 5df4b1cb-784e-4869-94b7-212c15b006ef
function euler42(words)
	char2int = Dict(Pair.('A':'Z', 1:26))
	upper_bound = maximum(length, words) * char2int['Z']
	tns = collect(Int, Iterators.takewhile(<=(upper_bound), n*(n+1)÷2 for n in 1:100))
	istriangleword = word->(sum(char2int[c] for c in word) in tns)
	
	return count(istriangleword, words)
end

# ╔═╡ 7f86715d-b95f-4f2e-b84f-2232efc8061a
euler42_answer = euler42(words)

# ╔═╡ 1ab55840-84a3-11eb-078d-139f98804f2e
begin
    submit_answer(euler42_answer; prob_num=42)
end

# ╔═╡ 1ab55840-84a3-11eb-1f1a-51bfada599a7
html"""
<h2>Problem 43: Sub-string divisibility</h2>
<p>The number, 1406357289, is a 0 to 9 pandigital number because it is made up of each of the digits 0 to 9 in some order, but it also has a rather interesting sub-string divisibility property.</p>
<p>Let <i>d</i><sub>1</sub> be the 1<sup>st</sup> digit, <i>d</i><sub>2</sub> be the 2<sup>nd</sup> digit, and so on. In this way, we note the following:</p>
<ul><li><i>d</i><sub>2</sub><i>d</i><sub>3</sub><i>d</i><sub>4</sub>=406 is divisible by 2</li>
<li><i>d</i><sub>3</sub><i>d</i><sub>4</sub><i>d</i><sub>5</sub>=063 is divisible by 3</li>
<li><i>d</i><sub>4</sub><i>d</i><sub>5</sub><i>d</i><sub>6</sub>=635 is divisible by 5</li>
<li><i>d</i><sub>5</sub><i>d</i><sub>6</sub><i>d</i><sub>7</sub>=357 is divisible by 7</li>
<li><i>d</i><sub>6</sub><i>d</i><sub>7</sub><i>d</i><sub>8</sub>=572 is divisible by 11</li>
<li><i>d</i><sub>7</sub><i>d</i><sub>8</sub><i>d</i><sub>9</sub>=728 is divisible by 13</li>
<li><i>d</i><sub>8</sub><i>d</i><sub>9</sub><i>d</i><sub>10</sub>=289 is divisible by 17</li>
</ul><p>Find the sum of all 0 to 9 pandigital numbers with this property.</p>
"""

# ╔═╡ 94d8afb7-5224-4a24-a572-51df36316422
primes(17)

# ╔═╡ 0521356c-3e29-48e6-91ac-0122e7a794b7
begin
	const p = primes(17)
	
	function issubstrdivisable(digs)
		for i in 2:8
			@inbounds @views digits2integer(digs[i:i+2]; natural=true)%p[i-1] == 0 || return false
		end
		return true
	end
end

# ╔═╡ b7da01db-e6b8-4e24-a899-884654cb2156
@test issubstrdivisable([1,4,0,6,3,5,7,2,8,9])

# ╔═╡ 3235536f-2e0c-4fd1-8394-0284e4b3c76c
euler43() = sum(digits2integer(p; natural=true) for p in permutations(0:9) if issubstrdivisable(p))

# ╔═╡ f99044d9-be39-4243-a6d2-d9e1b911d9b7
euler43_answer = euler43()

# ╔═╡ 1ab55840-84a3-11eb-3056-a3f495dd6e59
begin
    submit_answer(euler43_answer; prob_num=43)
end

# ╔═╡ 1ab55840-84a3-11eb-1712-01ee16e4e15c
html"""
<h2>Problem 44: Pentagon numbers</h2>
<p>Pentagonal numbers are generated by the formula, P<sub><var>n</var></sub>=<var>n</var>(3<var>n</var>−1)/2. The first ten pentagonal numbers are:</p>
<p class="center">1, 5, 12, 22, 35, 51, 70, 92, 117, 145, ...</p>
<p>It can be seen that P<sub>4</sub> + P<sub>7</sub> = 22 + 70 = 92 = P<sub>8</sub>. However, their difference, 70 − 22 = 48, is not pentagonal.</p>
<p>Find the pair of pentagonal numbers, P<sub><var>j</var></sub> and P<sub><var>k</var></sub>, for which their sum and difference are pentagonal and D = |P<sub><var>k</var></sub> − P<sub><var>j</var></sub>| is minimised; what is the value of D?</p>
"""

# ╔═╡ 2af17eba-4314-4c6c-ab3e-26e20c5a7b09
pentagonal(n) = n*(3n-1)÷2

# ╔═╡ 56135c3f-8e57-4839-8024-b2e2cf3f6963
pentagonal.(1:10)

# ╔═╡ 6af4dd0c-0790-4d7a-a7d1-b132c2cfb258
begin
	struct PentagonalIterator end
	
	Base.iterate(::PentagonalIterator) = (pentagonal(1), 1)
	Base.iterate(::PentagonalIterator, state::Integer) = (pentagonal(state+1), state+1)
	Base.IteratorSize(::Type{PentagonalIterator}) = Base.IsInfinite()
	Base.eltype(::Type{PentagonalIterator}) = Int
end

# ╔═╡ 7e50bb45-a062-4657-b01b-60763229d91d
ispentagonal(i) = i in Iterators.takewhile(x->x<=i, PentagonalIterator())

# ╔═╡ 0fa998c0-0b32-4387-a479-c75cb839bed4
begin
	@test ispentagonal(145)
	@test !ispentagonal(3)
end

# ╔═╡ 4ffdf65c-c9a9-4790-8a8d-0b0d67ccb4e5
function euler44()
	pentagonals = Int[]
	for pk in PentagonalIterator()
		for pj in reverse(pentagonals)
			if (pk-pj) in pentagonals && ispentagonal(pj+pk)
				return pk-pj
			end
		end
		push!(pentagonals, pk)
	end
	return -1 # should never happen
end

# ╔═╡ e7563448-cd05-4686-991f-ca3528891d99
euler44_answer = euler44()

# ╔═╡ 1ab55840-84a3-11eb-05b3-2dfcd01d335b
begin
    submit_answer(euler44_answer; prob_num=44)
end

# ╔═╡ 1ab55840-84a3-11eb-387f-398dd99056c8
html"""
<h2>Problem 45: Triangular, pentagonal, and hexagonal</h2>
<p>Triangle, pentagonal, and hexagonal numbers are generated by the following formulae:</p>
<table><tr><td>Triangle</td>
<td> </td>
<td>T<sub><i>n</i></sub>=<i>n</i>(<i>n</i>+1)/2</td>
<td> </td>
<td>1, 3, 6, 10, 15, ...</td>
</tr><tr><td>Pentagonal</td>
<td> </td>
<td>P<sub><i>n</i></sub>=<i>n</i>(3<i>n</i>−1)/2</td>
<td> </td>
<td>1, 5, 12, 22, 35, ...</td>
</tr><tr><td>Hexagonal</td>
<td> </td>
<td>H<sub><i>n</i></sub>=<i>n</i>(2<i>n</i>−1)</td>
<td> </td>
<td>1, 6, 15, 28, 45, ...</td>
</tr></table><p>It can be verified that T<sub>285</sub> = P<sub>165</sub> = H<sub>143</sub> = 40755.</p>
<p>Find the next triangle number that is also pentagonal and hexagonal.</p>
"""

# ╔═╡ 55794b0b-a889-4a23-93b8-933e7d9dedd5
triangle(n) = n*(n+1)÷2

# ╔═╡ 44556cbd-5a56-4fbe-b99b-06784cf9aac2
hexagonal(n) = n*(2n-1)

# ╔═╡ 51275c6e-7270-469e-8e06-88752b1f2458
begin
	struct HexagonalIterator end
	
	Base.iterate(::HexagonalIterator) = (1, 1)
	Base.iterate(::HexagonalIterator, state::Integer) = (hexagonal(state+1), state+1)
	Base.IteratorSize(::Type{HexagonalIterator}) = Base.IsInfinite()
	Base.eltype(::Type{HexagonalIterator}) = Int
end

# ╔═╡ 4cb6e8ec-3ed0-4659-ac59-5ab800628a10
ishexagonal(i) = i in Iterators.takewhile(x->x<=i, HexagonalIterator())

# ╔═╡ 4846d6a3-412a-4ec0-93b1-b6ac7b720fe3
begin
	@test ishexagonal(6)
	@test !ishexagonal(5)
end

# ╔═╡ 599b86a9-84e5-4fa2-ac06-59c8afc4b5ba
function euler45()
	start = 40755
	for i in 285+1:100_000
		t = triangle(i)
		if ishexagonal(t) && ispentagonal(t)
			return t
		end
	end
	return -1
end

# ╔═╡ 36aa1d2e-9326-4b4c-b573-309530f2714c
euler45_answer = euler45()

# ╔═╡ 1ab55840-84a3-11eb-1603-477748cbc400
begin
    submit_answer(euler45_answer; prob_num=45)
end

# ╔═╡ 1ab55840-84a3-11eb-3bd5-eba67eb376db
html"""
<h2>Problem 46: Goldbach's other conjecture</h2>
<p>It was proposed by Christian Goldbach that every odd composite number can be written as the sum of a prime and twice a square.</p>
<p class="margin_left">9 = 7 + 2×1<sup>2</sup><br />
15 = 7 + 2×2<sup>2</sup><br />
21 = 3 + 2×3<sup>2</sup><br />
25 = 7 + 2×3<sup>2</sup><br />
27 = 19 + 2×2<sup>2</sup><br />
33 = 31 + 2×1<sup>2</sup></p>
<p>It turns out that the conjecture was false.</p>
<p>What is the smallest odd composite that cannot be written as the sum of a prime and twice a square?</p>
"""

# ╔═╡ 1ab55840-84a3-11eb-1a99-f765f98001a1
begin
    submit_answer(nothing; prob_num=46)
end

# ╔═╡ 1ab55840-84a3-11eb-0a05-0d7a3bad5bee
html"""
<h2>Problem 47: Distinct primes factors</h2>
<p>The first two consecutive numbers to have two distinct prime factors are:</p>
<p class="margin_left">14 = 2 × 7<br />15 = 3 × 5</p>
<p>The first three consecutive numbers to have three distinct prime factors are:</p>
<p class="margin_left">644 = 2² × 7 × 23<br />645 = 3 × 5 × 43<br />646 = 2 × 17 × 19.</p>
<p>Find the first four consecutive integers to have four distinct prime factors each. What is the first of these numbers?</p>
"""

# ╔═╡ 1ab55840-84a3-11eb-14c3-7180a110316a
begin
    submit_answer(nothing; prob_num=47)
end

# ╔═╡ 1ab55840-84a3-11eb-3b36-cf43fd1f0163
html"""
<h2>Problem 48: Self powers</h2>
<p>The series, 1<sup>1</sup> + 2<sup>2</sup> + 3<sup>3</sup> + ... + 10<sup>10</sup> = 10405071317.</p>
<p>Find the last ten digits of the series, 1<sup>1</sup> + 2<sup>2</sup> + 3<sup>3</sup> + ... + 1000<sup>1000</sup>.</p>
"""

# ╔═╡ 66be19f0-abe7-4435-bcf8-2e8d84bdd91b
series(max) = sum(big(i)^(i) for i in 1:max)

# ╔═╡ 85db1bfb-91a8-48d8-a967-617c07bdbdec
@test series(10) == 10405071317

# ╔═╡ 262bb197-fb84-454b-8777-66b4b8bb3beb
euler48(max) = last(reverse!(digits(series(max))), 10)

# ╔═╡ 91ae53e9-4714-40c7-ba3a-841cb6dcf733
euler48(1000)

# ╔═╡ 3fa45174-c947-4951-9ddd-6da7f6279f10
euler48_answer = digits2integer(euler48(1000); natural=true)

# ╔═╡ 1ab55840-84a3-11eb-16ef-a5527875cfd2
begin
    submit_answer(euler48_answer; prob_num=48)
end

# ╔═╡ 1ab55840-84a3-11eb-306b-ed26025286a4
html"""
<h2>Problem 49: Prime permutations</h2>
<p>The arithmetic sequence, 1487, 4817, 8147, in which each of the terms increases by 3330, is unusual in two ways: (i) each of the three terms are prime, and, (ii) each of the 4-digit numbers are permutations of one another.</p>
<p>There are no arithmetic sequences made up of three 1-, 2-, or 3-digit primes, exhibiting this property, but there is one other 4-digit increasing sequence.</p>
<p>What 12-digit number do you form by concatenating the three terms in this sequence?</p>
"""

# ╔═╡ 79a0eea1-9ea7-47b3-9956-9a172e2982ca
function isunusualprime(num)
	isprime(num) || return false
	digs = digits(num);
	perms = permutations(digs);
	for i in (num+3330, num+6660)
		isprime(i) || return false
		digits(i) in perms || return false
	end
	return true
end

# ╔═╡ d9b9afe3-53bf-4706-a793-9c92bb821200
begin
	@test isunusualprime(1487)
	@test !isunusualprime(13)
end

# ╔═╡ d3534031-084a-408b-9549-fa2fe14b0b8d
function euler49()
	for n in 1000:9999
		n == 1487 && continue
		if isunusualprime(n)
			d1 = reverse!(digits(n))
			d2 = reverse!(digits(n+3330))
			d3 = reverse!(digits(n+6660))
			return digits2integer(vcat(d1,d2,d3); natural=true)
		end
	end
	return -1
end

# ╔═╡ 3533296f-bf76-4089-afd5-9958de395bcb
euler49_answer = euler49()

# ╔═╡ 1ab55840-84a3-11eb-2280-c530f1cf8c1e
begin
    submit_answer(euler49_answer; prob_num=49)
end

# ╔═╡ 1ab55840-84a3-11eb-3978-e3e4257debc9
html"""
<h2>Problem 50: Consecutive prime sum</h2>
<p>The prime 41, can be written as the sum of six consecutive primes:</p>
<div class="center">41 = 2 + 3 + 5 + 7 + 11 + 13</div>
<p>This is the longest sum of consecutive primes that adds to a prime below one-hundred.</p>
<p>The longest sum of consecutive primes below one-thousand that adds to a prime, contains 21 terms, and is equal to 953.</p>
<p>Which prime, below one-million, can be written as the sum of the most consecutive primes?</p>
"""

# ╔═╡ 8122f4d2-6bed-49b2-a6f2-205c649bdb11
const ps = primes(5_000);

# ╔═╡ 91029c3d-d547-4a1b-8129-ca7eefebdb72
function longest_sumprime(startidx, upperbound)
	endidx = startidx
	s = ps[startidx]
	
	# how long can we sum consecutive primes until we are > upperbound?
	while true
		endidx + 1 <= length(ps) || break
		tmp = s + ps[endidx+1]
		if tmp > upperbound
			break
		else
			endidx += 1
			s = tmp
		end
	end
	
	# substract primes (backwards) until the sum is a prime
	while true
		isprime(s) && break
		s -= ps[endidx]
		endidx -= 1
	end
	
	# return prime sum and sum length
	return s, endidx - startidx + 1
end

# ╔═╡ 4489c97c-bd85-4cfa-9a45-0e448f56aae8
function euler50(upperbound)
	primesums = [longest_sumprime(i, upperbound) for i in 1:length(ps)]
	sort!(primesums, by=x->x[2], rev=true)[1]
end

# ╔═╡ ddb3593c-5909-48e9-a7d4-b1fb10feb4d2
begin
	@test euler50(100) == (41, 6)
	@test euler50(1000) == (953, 21)
end

# ╔═╡ efa3a070-69eb-4d2f-9fd0-ff445a0b8cf4
euler50_answer, _ = euler50(1_000_000)

# ╔═╡ 1ab55840-84a3-11eb-0a62-113dc9999018
begin
    submit_answer(euler50_answer; prob_num=50)
end

# ╔═╡ Cell order:
# ╠═1ab55840-84a3-11eb-0b24-8bcce01520f4
# ╠═bdbd372b-23c9-421a-9130-d3ab03a33453
# ╟─1ab55840-84a3-11eb-0d06-bb5d9f576ac1
# ╠═117ec84e-65cd-40c4-b870-97afa9883dd1
# ╠═ed13dad1-e081-4689-92a5-6776c0eed8b4
# ╠═1fc45c36-7de2-48fe-a207-22c4f7d616ee
# ╠═1ab55840-84a3-11eb-2a1c-e1a0e40a8d60
# ╟─1ab55840-84a3-11eb-1581-0fa993520c3e
# ╠═3698fba9-9738-4dc3-8090-823604286874
# ╠═6a4cf689-5a60-4a3a-87e1-39d30dd0a5ef
# ╠═7bfa44f7-d1af-435e-8560-3dea3f6a52f9
# ╠═d6ef8eb1-c5b7-4974-bc7f-52198434d336
# ╠═2212d416-1c97-47e4-9c2b-ca72a9ab6fa3
# ╠═83aa34d1-0665-48d9-8328-ef82de35dce9
# ╠═1ab55840-84a3-11eb-0e89-d1cc04d4f5d5
# ╟─1ab55840-84a3-11eb-1b99-07b97224a53c
# ╠═7de59000-4b77-498a-923a-e08ade7e8376
# ╠═1ab55840-84a3-11eb-1209-4990258968d5
# ╟─1ab55840-84a3-11eb-2c82-35fad13828b3
# ╠═41decafb-c8a8-4246-a615-76b8599c0d66
# ╠═c6bddd98-f358-498a-b7db-10bdd1b58966
# ╠═fd93a123-86eb-49f0-b7fe-1bb0bc04b047
# ╠═1ab55840-84a3-11eb-2d5b-ed9672cecbd9
# ╟─1ab55840-84a3-11eb-3723-d199ccc7ae10
# ╠═8256b8d0-b545-4d25-8693-616022e2f408
# ╠═4a3fc8a5-d4bc-4bd3-baa1-7093fa06a642
# ╠═9421a49e-7035-4ab7-822e-8db9de3999b6
# ╠═a0d319ca-653b-4b27-b819-0997d07eca42
# ╠═1ab55840-84a3-11eb-24e8-e3f4e3be42ba
# ╟─1ab55840-84a3-11eb-145d-53e135d5c358
# ╠═a8199a55-008d-4456-b8d1-11f90eb89e83
# ╠═21c04794-a1ee-45a6-849a-2708412fb7a8
# ╠═1ab55840-84a3-11eb-0522-9fb06f5651f9
# ╟─1ab55840-84a3-11eb-2a71-e38fdab264f8
# ╠═dd0b5ae6-854a-42c7-93ca-eaa34ed30c0b
# ╠═39ce63f0-fa97-4547-a38c-8e71d8b79d86
# ╠═d8704c7a-99a2-4226-9cb4-bdfc5704466d
# ╠═1ab55840-84a3-11eb-2654-fd530b59c837
# ╟─5050cbf9-9d6e-47e5-a540-90cd646bdf1a
# ╠═d254a97c-17c0-4b9d-a460-a74e901fceef
# ╠═5029e897-0b36-43e3-bd13-e24aafc23356
# ╠═4766ca26-75f1-4733-a8c2-2aa4068113fb
# ╟─1ab55840-84a3-11eb-201b-1736c0f13319
# ╠═1d915f12-c146-4169-aab5-a1b71f442679
# ╠═32d6e229-7ba8-4ef2-8c8a-c98ffb6133ee
# ╠═c40ec4be-b167-4041-a5db-eaedb69fd656
# ╠═50113e18-0410-4ee5-8af9-c24bcc68b34a
# ╠═1ab55840-84a3-11eb-015a-ffb9b6554e7a
# ╟─1ab55840-84a3-11eb-2535-8b7135ec1f00
# ╠═e64505ac-5c36-416c-9bf4-dcd6aa8183bc
# ╠═69813cd7-0a4c-468a-b0c7-0bcf7c9fcd85
# ╠═bf505af1-4d7f-4cac-ad6a-e61a8069f8b3
# ╠═995a4cfa-8d6b-419f-ad19-c787840a43e4
# ╠═1ab55840-84a3-11eb-1f8d-a78f018810e0
# ╟─1ab55840-84a3-11eb-252c-416f92d2d8c9
# ╠═83c4cfb5-b0e7-45c3-9cb0-e728fc39ecfd
# ╠═a2204590-0283-4d8a-bab0-36045a64c358
# ╠═0ada01a1-1dca-4cb8-9a90-dca7920a404d
# ╠═1562aee3-9c3f-49d7-bfbf-7f1c94ed1155
# ╠═0ce1a24a-6873-4ac6-a691-2a556d2da464
# ╠═1ab55840-84a3-11eb-19fe-8d95e96357f4
# ╟─1ab55840-84a3-11eb-1dc7-01153bf71005
# ╠═6dfec37f-6764-47e9-864a-50daf873f966
# ╠═ee208648-92fb-4f05-a248-646a786011ab
# ╠═03c9fd12-310a-40fa-aa5d-c05ad69424b5
# ╠═1ab55840-84a3-11eb-1adb-6d608809f6e8
# ╟─1ab55840-84a3-11eb-0ea2-a3cf38b7ebe1
# ╠═af62eda5-5450-4e1d-b966-97ce405d609a
# ╠═8577d6a3-e3d7-40b5-96a1-200e1a0f6b58
# ╠═ac2f5026-37f2-479a-9329-253175b4a9da
# ╠═006efa46-3ce3-4484-9632-880ebd0350cb
# ╠═4934e258-9e98-4d75-8880-8f2917a2d9e1
# ╠═1ab55840-84a3-11eb-1bf7-d9716e2ce53c
# ╟─1ab55840-84a3-11eb-3859-81830cb33d9f
# ╠═3de6e0bf-7e59-4b34-a24f-e0f82ce40887
# ╠═0c2969a6-ea2c-4466-ae2d-dc9f309b5fdd
# ╠═da602110-304d-44d6-a14f-c49d9dd359ea
# ╠═272c900d-d4bb-4f4a-b6e7-c859bf217896
# ╠═d095f586-4ab3-4d4f-a73a-58c5b6741ef7
# ╠═b3431fe6-7f13-4d8b-a24e-0851afc7be67
# ╠═a3a3f702-c216-42fc-8f57-4308eca2e569
# ╠═1ab55840-84a3-11eb-339a-c9ec99dc92fe
# ╟─1ab55840-84a3-11eb-1af0-b70ef22929cf
# ╠═e3938b97-0119-4258-945e-96bdf0c35518
# ╠═0666b4ff-de6c-4a6f-8de6-c8e341ff1fe7
# ╠═bd37ffbd-2202-439a-94ee-a75a8f5633e1
# ╠═a60dfe7b-140f-476f-85cb-7d17d134e4ac
# ╠═2bbe5c6f-cd98-4c4a-9cbc-6b7ed6fced9c
# ╠═12623758-bd96-4a47-badf-c01e8bc26f8b
# ╠═d2a2b9a1-21ac-48de-abd7-ff16748365ea
# ╠═1ab55840-84a3-11eb-329a-2b02330da716
# ╟─1ab55840-84a3-11eb-15e4-c52876cc75aa
# ╠═e2f3e770-3591-45ca-abe4-3dc720abda8e
# ╠═c3f6eab1-56db-4206-b3b8-f9548aafa963
# ╠═5a5ce3dd-f81e-4ab3-aa7a-887b2eb1d502
# ╟─76b482e8-ab0a-4ab3-bcdc-f41adecc029a
# ╠═d1d186d9-6d62-4bcf-9a3a-b63c132e7953
# ╠═e75ed38b-7e92-4afc-94ac-0ec8f66bc8df
# ╠═ffcee764-83df-4f15-8cde-c5cd9a1a2b81
# ╠═4a875911-234c-422a-9a5d-7c94908fa9f3
# ╠═32d1844c-37c0-4a1c-b57b-d4bc2cf5e673
# ╟─1ab55840-84a3-11eb-3930-d75cab91a1b5
# ╠═3766903d-fe4a-437e-976e-03c8e204cc3a
# ╠═985ea127-8632-4887-8159-5edfe7af9df9
# ╠═1ab55840-84a3-11eb-1b75-ff5a3cf5af46
# ╟─1ab55840-84a3-11eb-3e0a-9fce2c7c8a4e
# ╟─4722f2e8-4525-4d3a-bcd4-a295921fa87d
# ╠═5df4b1cb-784e-4869-94b7-212c15b006ef
# ╠═7f86715d-b95f-4f2e-b84f-2232efc8061a
# ╠═1ab55840-84a3-11eb-078d-139f98804f2e
# ╟─1ab55840-84a3-11eb-1f1a-51bfada599a7
# ╠═94d8afb7-5224-4a24-a572-51df36316422
# ╠═0521356c-3e29-48e6-91ac-0122e7a794b7
# ╠═b7da01db-e6b8-4e24-a899-884654cb2156
# ╠═3235536f-2e0c-4fd1-8394-0284e4b3c76c
# ╠═f99044d9-be39-4243-a6d2-d9e1b911d9b7
# ╠═1ab55840-84a3-11eb-3056-a3f495dd6e59
# ╟─1ab55840-84a3-11eb-1712-01ee16e4e15c
# ╠═2af17eba-4314-4c6c-ab3e-26e20c5a7b09
# ╠═56135c3f-8e57-4839-8024-b2e2cf3f6963
# ╠═6af4dd0c-0790-4d7a-a7d1-b132c2cfb258
# ╠═7e50bb45-a062-4657-b01b-60763229d91d
# ╠═0fa998c0-0b32-4387-a479-c75cb839bed4
# ╠═4ffdf65c-c9a9-4790-8a8d-0b0d67ccb4e5
# ╠═e7563448-cd05-4686-991f-ca3528891d99
# ╠═1ab55840-84a3-11eb-05b3-2dfcd01d335b
# ╟─1ab55840-84a3-11eb-387f-398dd99056c8
# ╠═55794b0b-a889-4a23-93b8-933e7d9dedd5
# ╠═44556cbd-5a56-4fbe-b99b-06784cf9aac2
# ╠═51275c6e-7270-469e-8e06-88752b1f2458
# ╠═4cb6e8ec-3ed0-4659-ac59-5ab800628a10
# ╠═4846d6a3-412a-4ec0-93b1-b6ac7b720fe3
# ╠═599b86a9-84e5-4fa2-ac06-59c8afc4b5ba
# ╠═36aa1d2e-9326-4b4c-b573-309530f2714c
# ╠═1ab55840-84a3-11eb-1603-477748cbc400
# ╟─1ab55840-84a3-11eb-3bd5-eba67eb376db
# ╠═1ab55840-84a3-11eb-1a99-f765f98001a1
# ╟─1ab55840-84a3-11eb-0a05-0d7a3bad5bee
# ╠═1ab55840-84a3-11eb-14c3-7180a110316a
# ╟─1ab55840-84a3-11eb-3b36-cf43fd1f0163
# ╠═66be19f0-abe7-4435-bcf8-2e8d84bdd91b
# ╠═85db1bfb-91a8-48d8-a967-617c07bdbdec
# ╠═262bb197-fb84-454b-8777-66b4b8bb3beb
# ╠═91ae53e9-4714-40c7-ba3a-841cb6dcf733
# ╠═3fa45174-c947-4951-9ddd-6da7f6279f10
# ╠═1ab55840-84a3-11eb-16ef-a5527875cfd2
# ╟─1ab55840-84a3-11eb-306b-ed26025286a4
# ╠═79a0eea1-9ea7-47b3-9956-9a172e2982ca
# ╠═d9b9afe3-53bf-4706-a793-9c92bb821200
# ╠═d3534031-084a-408b-9549-fa2fe14b0b8d
# ╠═3533296f-bf76-4089-afd5-9958de395bcb
# ╠═1ab55840-84a3-11eb-2280-c530f1cf8c1e
# ╟─1ab55840-84a3-11eb-3978-e3e4257debc9
# ╠═8122f4d2-6bed-49b2-a6f2-205c649bdb11
# ╠═91029c3d-d547-4a1b-8129-ca7eefebdb72
# ╠═4489c97c-bd85-4cfa-9a45-0e448f56aae8
# ╠═ddb3593c-5909-48e9-a7d4-b1fb10feb4d2
# ╠═efa3a070-69eb-4d2f-9fd0-ff445a0b8cf4
# ╠═1ab55840-84a3-11eb-0a62-113dc9999018
