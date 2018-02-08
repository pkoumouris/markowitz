class PortfolioView extends React.Component {
	constructor(props){
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
			}
		};
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

	

	render (){

		let tempTotal = 0.0;

		for (let i=0;i<this.state.data.securities.length;i++){
			tempTotal += this.state.data.securities[i].price * this.state.data.securities[i].volume;
		}

		let secList = this.state.data.securities.map(security => 

			<tr>
				<td>
					{security.ticker}
				</td>
				<td>
					{security.name}
				</td>
				<td>
					{commaDecimal(security.volume)}
				</td>
				<td>
					{'$'+commaDecimal(security.price)}
				</td>
				<td>
					{'$'+commaDecimal(security.price * security.volume)}
				</td>
				<td>
					{commaDecimal(100.0*security.volume*security.price/tempTotal)+'%'}
				</td>
			</tr>

		);

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

		
		


		const ctx = document.getElementById("portfolioComposition");
        const portfolioComposition = new Chart(ctx, {
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
          			display: true,
          			position: 'right'
          		},
          		tooltips: {
          			enabled: true
          		},
          		plugins: {
          			legend: false,
          			outlabels: {
          				text: '%l %p',
          				color: 'white',
          				stretch: 45,
          				font: {
	                        resizable: true,
	                        minSize: 12,
	                        maxSize: 18
	                    }
          			}
          		}
          	}

       });

		

		return (
			<div>
				<h2>Breakdown</h2>
				<table
				className = "table table-striped table-hover">
					<thead>
						<td>
							Ticker
						</td>
						<td>
							Security
						</td>
						<td>
							Volume owned
						</td>
						<td>
							Current price
						</td>
						<td>
							Value held
						</td>
						<td>
							% of total
						</td>
					</thead>
					<tbody>
					{secList}
					<tr>
						<td></td>
						<td>
							<i>Cash</i>
						</td>
						<td></td><td></td>
						<td>
							{'$'+commaDecimal(this.state.data.cash)}
						</td>
						<td>
							{commaDecimal(100.0*this.state.data.cash/this.state.data.value)+'%'}
						</td>
					</tr>
					<tr>
						<td><b>
							Total
						</b></td>
						<td></td><td></td><td></td>
						<td><b>
							{'$'+commaDecimal(this.state.data.value)}
						</b></td>
						<td>100%</td>
					</tr>
					</tbody>
				</table>
				
			</div>
		);
	}


};









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


function getRandomColor() {
  var letters = '0123456789ABCDEF';
  var color = '#';
  for (var i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}
