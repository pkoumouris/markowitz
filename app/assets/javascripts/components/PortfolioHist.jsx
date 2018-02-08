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
			histPeriod: "month",
			loaded: false
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
				data: json,
				loaded: true
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

		let labelList = histData.map(
			timePoint => timePoint.date
		);

		const ctx2 = document.getElementById("portfolioHistory");
        const portfolioHistory = new Chart(ctx2, {
           type: 'line',
           data: {
	           labels: labelList,
	           datasets: [{
	               label: "Portfolio Value",
	               data: histList.reverse(),
	               borderColor: "#3e95cd"
	            }]

          	},
          	options: {
          		title: {
          			display: true,
          			text: 'Portfolio History: Intra'+this.state.histPeriod
          		},
          		elements: {
          			line: {
          				tension: 0
          			}
          		}
          	}

       	});

       	let changeDay = this.state.data.value - this.state.data.historyWeek[0].value;

       	if (changeDay > 0){
       		upDay = true;
       	} else {
       		upDay = false;
       	}

		return (<div>
					<h3>
					{this.state.loaded ? 
					"Your portfolio" : "Loading your portfolio..."}
					</h3>

					<h2>
						{'$'+commaDecimal(this.state.data.value)}
					</h2>
					<h4 class={upDay ? 
						"changeUp" : "changeDown"
					}>

					<span class={
						upDay ?
						"glyphicon glyphicon-arrow-up" :
						"glyphicon glyphicon-arrow-down"
					}></span>

					{this.state.loaded ? ' '+commaDecimal(
						Math.abs(100*changeDay/this.state.data.value)
					) + '% ' : " "}

					{this.state.loaded ? '$'+commaDecimal(

					Math.abs(changeDay)

					) : "Loading..."} 
					
					</h4>

					<table>

						<tr>
							<td>
								Portfolio cash balance: 
							</td>
							<td><b>
								{'$'+commaDecimal(this.state.data.cash)}
							</b></td>
						</tr>

						<tr>
							<td>
								Value of securities: 
							</td>
							<td><b>
								{'$'+commaDecimal(this.state.data.value-this.state.data.cash)}
							</b></td>
						</tr>

						<tr>
							<td>
								Expected annual return: 
							</td>
							<td><b>
								{commaDecimal(100.0*this.state.data.expRet)+'%'}
							</b></td>
						</tr>

						<tr>
							<td>
								Expected std deviation: 
							</td>
							<td><b>
								{commaDecimal(100*this.state.data.stdDev)+'%'}
							</b></td>
						</tr>

					</table>

					<h5>Change time period</h5>

					<table class="changeTimePeriod">

						<tr>



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



						</tr>
						<tr>



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


						</tr>

					</table>
					
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

	rightVal = Math.floor(value);
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