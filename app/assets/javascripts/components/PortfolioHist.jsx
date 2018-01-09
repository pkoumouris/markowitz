class PortfolioHist extends React.Component {
	
	constructor(props){;
		super(props);
		this.state = {
			data: {
				value: 0.0,
				cash: 0.0,
				securities: [{}],
				historyDay: [{}],
				historyWeek: [{}],
				historyMonth: [{}],
				historyYear: [{}],
				expRet: 0.0,
				stdDev: 0.0
			},
			histPeriod: "week"
		};
		this.seeIntraday = this.seeIntraday.bind(this);
		this.seeIntraweek = this.seeIntraweek.bind(this);
		this.seeIntramonth = this.seeIntramonth.bind(this);
		this.seeIntrayear = this.seeIntrayear.bind(this);
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

	seeIntraday(){
		this.setState({histPeriod: "day"});
	}

	seeIntraweek(){
		this.setState({histPeriod: "week"});
	}

	seeIntramonth(){
		this.setState({histPeriod: "month"});
	}

	seeIntrayear(){
		this.setState({histPeriod: "year"});
	}

	render() {
		if (this.state.histPeriod === "day"){
			histData = this.state.data.historyDay;
		} else if (this.state.histPeriod === "week"){
			histData = this.state.data.historyWeek;
		} else if (this.state.histPeriod === "month"){
			histData = this.state.data.historyMonth;
		} else if (this.state.histPeriod === "year"){
			histData = this.state.data.historyYear;
		}

		let histList = histData.map(
			timePoint => timePoint.value
		);

		const ctx2 = document.getElementById("portfolioHistory");
        const portfolioHistory = new Chart(ctx2, {
           type: 'line',
           data: {
	           labels: ['June','July','August'],
	           datasets: [{
	               label: "Portfolio Value",
	               data: histList,
	               borderColor: "#3e95cd"
	            }]

          	},
          	options: {
          		title: {
          			display: true,
          			text: 'Portfolio History: Intra'+this.state.histPeriod
          		}
          	}

       	});

		return (<div>
					<h4>Current value</h4>

					<h2>
						{'$'+commaDecimal(this.state.data.value)}
					</h2>
					<h4 id="change"><span class="glyphicon glyphicon-arrow-up"></span> 0.20% $23.11</h4>

					<h5>Portfolio cash balance: {'$'+commaDecimal(this.state.data.cash)}</h5>

					<h5>Value of securities: {'$'+commaDecimal(this.state.data.value-this.state.data.cash)}</h5>

					<p>Expected annual return: <b>{commaDecimal(100.0*this.state.data.expRet)+'%'}</b></p>

					<p>Estimated standard deviation: <b>{commaDecimal(100*this.state.data.stdDev)+'%'}</b></p>

					<h5>Change time period</h5>

					<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntraday}>
						<span class="intraToggle">
							Intraday
						</span>
					</button>

					<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntraweek}>
						<span class="intraToggle">
							Intraweek
						</span>
					</button>

					<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntramonth}>
						<span class="intraToggle">
							Intramonth
						</span>
					</button>

					<button type="button" class="btn btn-primary btn-xs" onClick={this.seeIntrayear}>
						<span class="intraToggle">
							Intrayear
						</span>
					</button>
					
				</div>);
	}


}


function commaDecimal(value) {

	decimalPt = value - Math.floor(value);
	decimalPt *= 100;
	decimalPt = Math.round(decimalPt);
	if (decimalPt===0){
		decimalPt = '00';
	} else if (decimalPt<10) {
		decimalPt = '0' + decimalPt.toString();
	} else {
		decimalPt = decimalPt.toString();
	}

	rightVal = Math.round(value);
	rightVal = rightVal.toString();

	str = '';

	for ( i=0 ; i<rightVal.length ; i++ ){
		
		if ( !(i===0) && i%3===0 ){
			str = ',' + str;
		}

		str = rightVal[rightVal.length - 1 - i] + str;

		
	}

	return str + '.' + decimalPt;
}