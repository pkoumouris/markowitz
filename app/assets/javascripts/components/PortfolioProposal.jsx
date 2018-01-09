class PortfolioProposal extends React.Component {
	constructor(props){
		super(props);
		this.state = {
			proposalStatus: "noProposal",
			stdDev: 0.0,
			seeCurrent: true,
			data: {
				securities: [{}],
				expRet: 0.0,
				stdDev: 0.0,
				value: 0.0
				},
			proposalResponse: {
				status: 0,
				proposal: {
					securities: [{}],
					stddev: 0.0,
					ret: 0.0
				}
			},
			riskRangeProb: 90.0,
			riskRangeExpRet: 2.00
		};

		this.handleRiskRangeChange = this.handleRiskRangeChange.bind(this);

		this.handleRiskRangeSubmit = this.handleRiskRangeSubmit.bind(this);
		
		this.postRequestSD = this.postRequestSD.bind(this);

		this.proposalResultMessage = this.proposalResultMessage.bind(this);
	}

	componentDidMount() {
		let URL = `http://localhost:3000/api/portfolios/${this.props.id}`;
		let component = this;

		fetch(URL)
		.then( (response) => {
			if (response.ok){
				return response.json();
			}
			throw new Error('Request fail');
		})
		.then( json => {
			component.setState({
				data: json
			});
		});
	}

	handleRiskRangeChange(event) {
		const target = event.target;
		const value = target.value;
		const name = target.name;

		this.setState({
			[name]: value
		});

	}

	postRequestSD(){
		let URL = `http://localhost:3000/api/portfolios/${this.props.id}`;
		let component = this;

		SD = String(this.state.stdDev);

		let postData = {
			requestType:"proposal",
			data:{
				type:"optimise",
				preferences:{
					stddev:SD
				}
			}
		};

		fetch(URL,
			{
				headers: {
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				},
				method: 'PATCH',
				body: JSON.stringify(postData)
			}
		)
		.then( (response) => {
			if (response.ok){
				return response.json();
			}
			throw new Error('Request fail');
		})
		.then( json => {

			if (json.status === 200){
				component.setState({proposalStatus: "success"});
			} else {
				component.setState({proposalStatus: "error"});
			}

			component.setState({
				proposalResponse: json
			});

			component.setState({
				basicData: true
			})

		});
	}

	handleRiskRangeSubmit(){
		P = this.state.riskRangeProb/100.0;
		d = this.state.riskRangeExpRet;
		SD = d/(Math.sqrt(2)*erfinv(P));
		this.setState({stdDev: 0.01*SD});

		this.setState({proposalStatus: "waiting"});

		this.postRequestSD();

	}

	proposalResultMessage(){

		const str1 = "Click 'Propose Portfolio' to see what your portfolio would look like.";
		const str2 = "Loading your portfolio...";
		const str3 = "Allocan could not calculate a portfolio given your parameters. Please check your parameters again.";
		const str4 = "There was an error loading your portfolio. Please try again.";
		const str5 = "Allocan succesfully found a portfolio.";

		if (this.state.proposalStatus === "noProposal"){
			return str1;
		} else if (this.state.proposalStatus === "waiting"){
			return str2;
		} else if (this.state.proposalStatus === "parameterError"){
			return str3;
		} else if (this.state.proposalStatus === "error"){
			return str4;
		} else if (this.state.proposalStatus === "success"){
			return str5;
		} else {
			return str5;
		}
	}

	render(){

		let value = this.state.data.value/1.001;

		let secList;

		if (this.state.proposalStatus === "noProposal"){
			secList = <h3>perfect</h3>;
		} else {
			secList = this.state.proposalResponse.proposal.securities.map ( security =>

				<tr>
					<td>
						{security.ticker}
					</td>
					<td>
						{security.name}
					</td>
					<td>
						{commaDecimal(100.0*security.weight)+'%'}
					</td>
					<td>
						{'$'+commaDecimal(value*security.weight)}
					</td>
				</tr>
			)
		}

		let secContent;

		if (this.state.proposalStatus === "noProposal"){
			secContent = (<p>Click 'Propose Portfolio' to see what your portfolio would look like.</p>);
		} else if (this.state.proposalStatus === "waiting") {
			secContent = <h4>Loading...</h4>;
		} else {
			secContent = (
			<div>
				<h4>Expected return: {this.state.proposalResponse.proposal.ret}%</h4>

				<h4>Standard deviation {100.0*this.state.proposalResponse.proposal.stddev}%</h4>

				<table className = "table table-striped table-hover">
					<thead>
						<td>
							Ticker
						</td>
						<td>
							Name
						</td>
						<td>
							Weight
						</td>
						<td>
							Proposed value
						</td>
					</thead>
					<tbody>
						{secList}
						<td>
							<b>Total value</b>
						</td>
						<td></td><td></td>
						<td>
							<b>{'$'+commaDecimal(this.state.data.value)}</b>
						</td>
					</tbody>
				</table>
			</div>
			);
		}


		let secNameList = this.state.data.securities.map(
		security =>

			security.name

		);

		let secValueList = this.state.data.securities.map(
		security =>

			security.volume * security.price

		);

		secNameList.push("Cash");
		secValueList.push(this.state.data.cash);

		let colorList = secNameList.map(
		element =>
			getRandomColor()
		);


		const ctx = document.getElementById("portfolioProposal");
        const portfolioProposal = new Chart(ctx, {
           type: 'pie',
           data: {
	           labels: secNameList,
	           datasets: [{
	               label: '# of Likes',
	               data: secValueList,
	               backgroundColor: colorList
	            }],

          	},
          	options: {
          		legend: {
          			display: false,
          			position: 'left'
          		},
          		tooltips: {
          			enabled: true
          		}
          	}

        });




        if (this.state.proposalStatus === "success"){
	        let secNameList2 = this.state.proposalResponse.proposal.securities.map(
	        security =>

	        	security.name

	        );

	        let secValueList2 = this.state.proposalResponse.proposal.securities.map(
	        security =>

	        	security.weight

	        );

	        let colorList2 = secNameList2.map(
			element =>
				getRandomColor()
			);

	        const ctx2 = document.getElementById("portfolioProposal2");
	        const portfolioProposal2 = new Chart(ctx2, {
	           type: 'pie',
	           data: {
		           labels: secNameList2,
		           datasets: [{
		               label: '# of Likes',
		               data: secValueList2,
		               backgroundColor: colorList2
		            }],

	          	},
	          	options: {
	          		legend: {
	          			display: false,
	          			position: 'right'
	          		},
	          		tooltips: {
	          			enabled: true
	          		}
	          	}

	        });
	    }

	    const ctx4 = document.getElementById("riskReturn");
	    const riskReturn = new Chart(ctx4,
	    	{
	    		type: 'scatter',
	    		data: {
	    			datasets: [{
	    				label: "Portfolio risk-return",
	    				pointRadius: 6,
	    				pointBorderWidth: 3,
	    				pointBackgroundColor: "#4286f4",
	    				data: [
	    					{
	    						x: 100.0*this.state.proposalResponse.proposal.stddev,
	    						y: 100.0*this.state.proposalResponse.proposal.ret
	    					}
	    				]}
	    			]
	    		},
	    		options: {
	    			scales: {
	    				yAxes: [{
	    					scaleLabel: {
	    						display: true,
	    						labelString: 'Return (%)'
	    					},
	    					ticks: {
	    						suggestedMin: 0.0
	    					}
	    				}],
	    				xAxes: [{
	    					scaleLabel: {
	    						display: true,
	    						labelString: 'Standard Deviation (Risk) (%)'
	    					},
	    					ticks: {
	    						suggestedMin: 0.0
	    					}
	    				}]
	    			}
	    		}
	    	}
	    );


		return (
			<div>
				<div className="buildProposal">
					<h2>Build your portfolio here</h2>
					<p><b>Set your portfolio preferences, and then see how your portfolio will look.</b></p>
					<form>
						I want a 
							<input
								name="riskRangeProb" 
								type="number" 
								value={this.state.riskRangeProb}
								onChange={this.handleRiskRangeChange} 
								 />
						% chance of earning within 
							<input
								name="riskRangeExpRet" 
								type="number" 
								value={this.state.riskRangeExpRet} 
								onChange={this.handleRiskRangeChange} 
								 /> 
							
						% points of my expected return.<br />
						<button type="button" className="btn btn-primary" onClick={this.handleRiskRangeSubmit}>Propose Portfolio</button>
					</form>
				</div>
				<div id={
					this.state.proposalStatus === "success" ? 
					"proposalBelowSuccess" : 
					"proposalBelow"
				} >

					
					<h2>Your proposed portfolio</h2>

					<h4>{this.state.proposalStatus === "noProposal" ? "You haven't told us what you want yet." : ""}</h4>

					{this.state.proposalStatus === "success" ? <p><b>Success! </b>We found the following information on your proposed portfolio:</p> : ""}

					<p>{this.state.proposalStatus === "noProposal" ? "Use the above tool to set your preferences, click 'Propose Portfolio', and we'll do the rest!" : ""}</p>

					<h4>{this.state.proposalStatus === "waiting" ? "Loading..." : ""}</h4>

					<p>{this.state.proposalStatus === "waiting" ? "We're compiling your proposed portfolio." : ""}</p>

					<h4>{this.state.proposalStatus === "error" ? "There was an error." : ""}</h4>

					<p>{this.state.proposalStatus === "error" ? "There may be an error with your connection, or perhaps the parameters you put in." : ""}</p>
					

					<div class={this.state.proposalStatus === "success" ? "visible" : "invisible"}>

					

					{secContent}

					<div class="row">
						<h2>Compare portfolios</h2>

						<div class="col-sm-6">

						<h3>Your current portfolio</h3>

						<canvas id="portfolioProposal" height="150px"></canvas>

						</div>
						<div class="col-sm-6">

						<h3>Your proposed portfolio</h3>

						<canvas id="portfolioProposal2" height="150px"></canvas>

						</div>

						

					</div>

					<h2>Risk-return</h2>
					<canvas id="riskReturn" height="150px"></canvas>

					</div>

				</div>

			</div>
		);
	}

}

class TestClass2 extends PortfolioProposal {

	render(){
		return (<h2>{
			this.state.proposalStatus === "noProposal" ? 
			"hello" : "yes"
			}</h2>);
	}
}

class TestClass extends React.Component {
	constructor(props){
		super(props);
		this.state = {
			message: ""
		}
	}

	componentDidMount() {
		let check = this.props.status;

		const str1 = "Click 'Propose Portfolio' to see what your portfolio would look like.";
		const str2 = "Loading your portfolio...";
		const str3 = "Allocan could not calculate a portfolio given your parameters. Please check your parameters again.";
		const str4 = "There was an error loading your portfolio. Please try again.";
		const str5 = "Allocan succesfully found a portfolio.";

		if (check === "noProposal"){
			this.setState({message: str1});
		} else if (check === "waiting"){
			this.setState({message: str2});
		} else if (check === "parameterError"){
			this.setState({message: str3});
		} else if (check === "error"){
			this.setState({message: str4});
		} else if (check === "success"){
			this.setState({message: str5});
		} else {
			this.setState({message: str5});
		}
	}

	render(){
		return <h4>{this.state.message}</h4>
	}
}


function erfinv(x){
        let z;
        let a  = 0.147;                                                   
        let the_sign_of_x;
        if(0==x) {
            the_sign_of_x = 0;
        } else if(x>0){
            the_sign_of_x = 1;
        } else {
            the_sign_of_x = -1;
        }

        if(0 != x) {
            let ln_1minus_x_sqrd = Math.log(1-x*x);
            let ln_1minusxx_by_a = ln_1minus_x_sqrd / a;
            let ln_1minusxx_by_2 = ln_1minus_x_sqrd / 2;
            let ln_etc_by2_plus2 = ln_1minusxx_by_2 + (2/(Math.PI * a));
            let first_sqrt = Math.sqrt((ln_etc_by2_plus2*ln_etc_by2_plus2)-ln_1minusxx_by_a);
            let second_sqrt = Math.sqrt(first_sqrt - ln_etc_by2_plus2);
            z = second_sqrt * the_sign_of_x;
        } else { // x is zero
            z = 0;
        }
  return z;
}