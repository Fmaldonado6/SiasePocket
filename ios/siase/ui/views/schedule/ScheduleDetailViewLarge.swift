//
//  ScheduleDetailViewLarge.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class ScheduleDetailViewLarge:UIStackView{
    
    private let hourHeight = 78.0
    
    private let hoursView:UIStackView = {
        let view = UIStackView()
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.axis = .vertical

        return view
    }()
    
    private let scrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let scheduleView:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    

    private var onClassClicked:(ClassDetail)-> Void = {classDetail in}
    
    func setOnClassClicked(listener: @escaping (ClassDetail) -> Void){
        self.onClassClicked = listener
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.axis = .horizontal
        self.addArrangedSubview(hoursView)
        self.addArrangedSubview(scrollView)
        
        scrollView.addSubview(scheduleView)
        
        
        for _ in 0...5{
            let view = UIView()
            view.widthAnchor.constraint(equalToConstant: 300).isActive = true
            scheduleView.addArrangedSubview(view)
        }
        
        NSLayoutConstraint.activate([
            scheduleView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scheduleView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            scheduleView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scheduleView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
        
        rebuild()
    }
    
    private func setupDays(container:UIView, day:String){
        
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.text = day
        
        container.addSubview(text)
        
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray5
        
        container.addSubview(divider)
        

        
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: container.topAnchor,constant: 10),
            text.widthAnchor.constraint(equalTo:container.widthAnchor),
            text.heightAnchor.constraint(equalToConstant: hourHeight),
            
            divider.topAnchor.constraint(equalTo: container.topAnchor,constant: 10),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.rightAnchor.constraint(equalTo: container.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: hourHeight*32)
        ])
        
    }
    
    private func setupHours(){
        let spacer = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: hourHeight).isActive = true
            return view
        }()
        
        hoursView.addArrangedSubview(spacer)
        
        
        var i = 7.0
        while i  < 22.5{
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            var dayOrNight = "a.m."
            var realHour = Int(i)
            
            if (i > 12.5) {
                realHour -= 12
                dayOrNight = "p.m."
            }
            
            let hour = i.remainder(dividingBy: 1) != 0.0 ? "\(realHour):30 \(dayOrNight)" : "\(realHour):00 \(dayOrNight)"
            
            label.text = hour
            label.font = label.font.withSize(14)
            label.textAlignment = .center
            
            
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: hourHeight),
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.widthAnchor.constraint(equalTo:container.widthAnchor)
            ])
            
            hoursView.addArrangedSubview(container)
            i += 0.5
        }
    }
    
    private func setupDividers(classView:UIView){
        
        let spacer = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        classView.addSubview(spacer)
        
        NSLayoutConstraint.activate([
            spacer.heightAnchor.constraint(equalToConstant: hourHeight),
            spacer.widthAnchor.constraint(equalTo: classView.widthAnchor),
            spacer.topAnchor.constraint(equalTo: classView.topAnchor)
            
        ])
        
        for i in 0...30{
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            let divider = UILabel()
            divider.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(divider)
            divider.backgroundColor = .systemGray5
            classView.addSubview(container)
            
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: hourHeight),
                container.widthAnchor.constraint(equalTo: classView.widthAnchor),
                container.topAnchor.constraint(equalTo: spacer.bottomAnchor, constant: hourHeight * Double(i)),
                divider.topAnchor.constraint(equalTo: container.topAnchor,constant: 10),
                divider.widthAnchor.constraint(equalTo:container.widthAnchor),
                divider.heightAnchor.constraint(equalToConstant: 1)
            ])
            
        }
    }
    
    func setUpSchedule(schedule:ScheduleDetail){
        rebuild()
        setupClasses(classContainer: scheduleView.subviews[0], classes: schedule.lunes.getFormattedDetail())
        setupClasses(classContainer: scheduleView.subviews[1], classes: schedule.martes.getFormattedDetail())
        setupClasses(classContainer: scheduleView.subviews[2], classes: schedule.miercoles.getFormattedDetail())
        setupClasses(classContainer: scheduleView.subviews[3], classes: schedule.jueves.getFormattedDetail())
        setupClasses(classContainer: scheduleView.subviews[4], classes: schedule.viernes.getFormattedDetail())
        setupClasses(classContainer: scheduleView.subviews[5], classes: schedule.sabado.getFormattedDetail())
    }
    
    private func setupClasses(classContainer:UIView,classes:[ClassDetail]){
        
        let spacer = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        classContainer.addSubview(spacer)
        
        NSLayoutConstraint.activate([
            spacer.heightAnchor.constraint(equalToConstant: hourHeight),
            spacer.widthAnchor.constraint(equalTo: classContainer.widthAnchor),
            spacer.topAnchor.constraint(equalTo: classContainer.topAnchor)
            
        ])
        
        
        
        let realHourHeight = hourHeight * 2
        let initialTimeDate = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        let initialTime = Calendar.current.dateComponents([.hour,.minute], from: initialTimeDate)
        for classDetail in classes{
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            let classView = ClassView()
            classView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(classView)
            classContainer.addSubview(container)
            
            let startTime = Date.parseTime(time:classDetail.horaInicio!)
            let endTime = Date.parseTime(time:classDetail.horaFin!)
            
            let minuteDifference = Calendar.current.dateComponents([.minute], from: initialTime, to: startTime).minute!
            let duration = Calendar.current.dateComponents([.minute], from: startTime,to: endTime).minute!
            
            let margin = (Double(minuteDifference) / 60.0) * realHourHeight
            let height = (Double(duration) / 60.0) * realHourHeight
            
            classView.setClassName(text: classDetail.nombre ?? "")
            classView.setTimeName(text: classDetail.horaInicio! + " - " + classDetail.horaFin!)
            
            classView.setClickListener {
                self.onClassClicked(classDetail)
            }
            
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: height),
                container.widthAnchor.constraint(equalTo: classContainer.widthAnchor),
                container.topAnchor.constraint(equalTo: spacer.bottomAnchor, constant:margin),
                
                classView.topAnchor.constraint(equalTo: container.topAnchor,constant: 20),
                classView.leadingAnchor.constraint(equalTo:container.leadingAnchor,constant: 10),
                classView.trailingAnchor.constraint(equalTo:container.trailingAnchor,constant: -10),
                classView.heightAnchor.constraint(equalToConstant: height-20),
                
            ])
            
        }
    }
    
    private func rebuild(){
        
        for subView in hoursView.subviews as [UIView] {
            subView.removeFromSuperview()
        }
        
        
        for (i,subView) in scheduleView.subviews.enumerated() {
            subView.subviews.forEach{it in it.removeFromSuperview()}
            setupDays(container: subView, day: DateHelpers.weekDays[i])
            setupDividers(classView: subView)
        }
        
        setupHours()
    }
    
    
    required init(coder: NSCoder) {
        fatalError("Not implementef")
    }
}
